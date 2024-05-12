import 'dart:convert';
import 'dart:io';
import 'package:capstone_frontend/const/api_utils.dart';
import 'package:capstone_frontend/screen/chatbot/chat_resp_model.dart';
import 'package:capstone_frontend/screen/chatbot/chat_send_model.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:google_speech/google_speech.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {

  //음성 녹음
  late FlutterSoundRecorder audioRecord;
  late audio_players.AudioPlayer audioPlay;
  late String audioPath;
  String? content = '';
  bool? keyboardMode = false;
  bool isRecording = false;
  bool is_Transcribing = false;
  just_audio.AudioPlayer audioPlayer = just_audio.AudioPlayer();
  String threadId = '';
  String message1 = '';
  int emotion = 0;
  int status = 0;


  @override
  void initState() {
    super.initState();
    audioPlay = audio_players.AudioPlayer();
    audioRecord = FlutterSoundRecorder();
    audioPath = '';
    setPermissions();
  }

  @override
  void dispose() {
    audioPlay.dispose();
    super.dispose();
  }

  void setPermissions() async {
    await Permission.microphone.request();
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
  }

  Future<void> transcribe() async {
    setState(() {
      is_Transcribing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('asset/stt-test-418715-4b9278f2d459.json'))}');
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 16000,
        audioChannelCount: 1,
        languageCode: 'ko-KR');

    final audio = await _getAudioContent(audioPath);
    await speechToText.recognize(config, audio).then((value) {
      if (value.results.isNotEmpty) {
        setState(() {
          content = value.results.map((e) => e.alternatives.first.transcript).join('\n');
          ChatMessage message = ChatMessage(
            user: _currentUser,
            createdAt: DateTime.now(),
            text: content!,
          );
          print(content);
          getChatResponse(message);
        });
      } else {
        setState(() {
          content = '음성 인식 결과가 없습니다. 다시 시도해주세요.';
        });
        print('No results found');
      }
    }).catchError((error) {
      setState(() {
        content = '음성 인식 중 오류가 발생했습니다: $error';
      });
    }).whenComplete(() {
      setState(() {
        is_Transcribing = false;
        print('출력 완료');
      });
    });
  }

  Future<List<int>> _getAudioContent(filePath) async {
    //로컬 디렉토리 파일을 넘겨주기 위해서는 이 방법을 해야함.
    File file = File(filePath);
    List<int> voiceData = await file.readAsBytes();
    return voiceData;
  }

  Future<void> startRecording() async {
    try {
      String tempDir = (await getTemporaryDirectory()).path;
      audioPath = '$tempDir/recording.wav'; // 저장할 파일 경로
      await audioRecord.openRecorder();
      await audioRecord.startRecorder(toFile: audioPath);
      setState(() {
        isRecording = true;
      });
    } catch (e) {
      // print('Error Start Recording : $e');
      print('시작 에러');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stopRecorder();
      // print(path);
      setState(() {
        isRecording = false;
      });
      await audioRecord.closeRecorder();
      if(_messages.isEmpty){
        await createChatThread(UserManager().getUserId()!);
      }
      await transcribe();

    } catch (e) {
      print('Error Stopping record : $e');
      print('정지 에러');
    }
  }

  //Clova Api 연결, 문자, 감정, 감정의 강도, 음색
  Future<Uint8List> clovaTTS(String text, int emotion, int volume,  int emotionStrength, int alpha, int speed) async {
    //키 값
    const String clientId = '574nlmj8za';
    const String clientSecret = 'pS4OXOd0H1AqPKUeLabIqlVwMv8VJZCCuynxstAe';
    const String url = 'https://naveropenapi.apigw.ntruss.com/tts-premium/v1/tts';

    //헤더
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-NCP-APIGW-API-KEY-ID': clientId,
      'X-NCP-APIGW-API-KEY': clientSecret,
    };

    //요청 정보
    Map<String, String> body = {
      'speaker': 'vara',
      //목소리 종류
      'speed': '0',
      //속도, -5~5 (낮으면 빠름)
      'text': text,
      //문장
      'volume': volume.toString(),
      //음성 볼륨, -5~5 (클수록 큼)
      'emotion': emotion.toString(),
      //음성 감정, 0~3(중립, 슬픔, 기쁨, 분노)
      'emotion-strength': emotionStrength.toString(),
      // 감정의 강도, 0~2(약함, 보통, 강함)
      'alpha': alpha.toString()
      // 음색, -5~5 (높을수록 높음)
    };

    //http post 요청
    final response = await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      String errorMessage = response.body;
      throw Exception(errorMessage);
    }
  }

  Future<void> _playAudio(String text, int emotion, int volume, int emotionStrength, int alpha, int speed) async {
    //tts 결과를 반환, 데이터 타입 -> Uint8List
    final voice = await clovaTTS(text, emotion, volume, emotionStrength, alpha, speed);

    // 임시 파일로 변환하여 재생
    final tempFile = File('${Directory.systemTemp.path}/clova.mp3');
    await tempFile.writeAsBytes(voice);
    print('임시 파일 경로: $tempFile');

    audioPlayer.setFilePath(tempFile.path);
    audioPlayer.play();
  }

  Future<String> createChatThread(String userId) async {
    final response = await http.post(
      Uri.parse('$ip/Create_Chatroom/chatroom'),
      headers:{'Content-Type': 'application/json',},
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        threadId = data['chat_thread'];
      });
      return data['chat_thread'];
    }
    else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      throw Exception('Error: ${data['message']}');
    }
    else {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<void> sendMessage(ChatSendModel model) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$ip/Send_Message_Dairy/model'))
        ..fields['threadid'] = model.threadId
        ..fields['userid'] = model.userId
        ..fields['content'] = model.content;

      if (model.audioFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'fileTest',
          model.audioFile.path,
          filename: 'emotion.wav',
        ));
      }

      var resp = await request.send();
      if (resp.statusCode == 200) {
        String responseBody = await resp.stream.bytesToString();
        var data = jsonDecode(responseBody);
        ChatRespModel respModel = ChatRespModel.fromJson(data);
        setState(() {
          message1 = respModel.message;
          emotion = respModel.emotion;
          status = respModel.status;
        });
        print('서버로부터의 응답: ${data['message']}, 감정: ${data['emotion']}');
      } else {
        throw Exception('메시지 전송 실패: 상태 코드 ${resp.statusCode}');
      }
    } catch (e) {
      print('오류 발생: $e');
      // 사용자에게 피드백을 제공하는 UI 업데이트를 여기에 추가할 수 있습니다.
    }
  }


  final ChatUser _currentUser =
  ChatUser(id: '1', firstName: 'Kim', lastName: 'KeonDong');
  final ChatUser _gptChatUser =
  ChatUser(id: '2', firstName: 'Chat', lastName: 'Gpt');

  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 166, 126, 1),
        title: const Text(
          '공감 대화 챗봇',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              '일기 작성',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          keyboardMode ?? false
              ? IconButton(
            onPressed: () {
              setState(() {
                keyboardMode = false;
              });
            },
            icon: const Icon(Icons.mic_none_outlined),
          )
              : IconButton(
            onPressed: () {
              setState(() {
                keyboardMode = true;
              });
            },
            icon: const Icon(Icons.keyboard_alt_outlined),
          ),
        ],
      ),
      body: DashChat(
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.lightBlueAccent,
          containerColor: Color.fromRGBO(0, 166, 126, 1,),
          textColor: Colors.white,
        ),
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        inputOptions: InputOptions(
          sendOnEnter: true,
          inputDisabled: keyboardMode ?? false ? false : true,
          inputDecoration: InputDecoration(
            hintText: keyboardMode == false
                ? "위의 마이크로 나에게 너의 감정을 들려줘!"
                : '키보드 모드 활성화 되었습니다.',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(24),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        messages: _messages,
      ),
      floatingActionButton: keyboardMode == false
          ? Align(
        alignment: const Alignment(0, 0.99),
        child: FloatingActionButton(
          onPressed: () =>
          isRecording ? stopRecording() : startRecording(),
          backgroundColor: isRecording
              ? Colors.red
              : const Color.fromRGBO(0, 166, 126, 1),
          child: const Icon(Icons.mic_none_outlined, size: 24),
        ),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });
    ChatSendModel sendModel = ChatSendModel(
      threadId: threadId,
      userId: UserManager().getUserId()!,
      content: m.text,
      audioFile: File(audioPath),
    );

    sendMessage(sendModel).whenComplete(
          () {
        setState(() {
          _messages.insert(0,
            ChatMessage(
              user: _gptChatUser,
              createdAt: DateTime.now(),
              text: message1,
            ),
          );
          _typingUsers.remove(_gptChatUser);
        });
        // _playAudio(message1, emotion, 5, 2, 0,-5);
      },
    );
  }
}
