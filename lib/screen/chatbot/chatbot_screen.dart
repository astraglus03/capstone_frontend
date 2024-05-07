import 'dart:io';
import 'package:capstone_frontend/const/ip.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  bool? keyboardMode = false;
  //음성 녹음
  late FlutterSoundRecorder audioRecord;
  late audio_players.AudioPlayer audioPlay;
  late String audioPath;
  String? content = '';
  bool isRecording = false;
  bool is_Transcribing = false;
  just_audio.AudioPlayer audioPlayer = just_audio.AudioPlayer();
  String emotionResult = '';

  @override
  void initState() {
    super.initState();
    audioPlay = audio_players.AudioPlayer();
    audioRecord = FlutterSoundRecorder();
    audioPath='';
    setPermissions();
  }

  @override
  void dispose(){
    audioPlay.dispose();
    super.dispose();
  }

  void setPermissions() async {
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
  }


  Future<void> transcribe() async {
    setState(() {
      is_Transcribing = true;
    });
    final serviceAccount = ServiceAccount.fromString('${(await rootBundle.loadString('asset/stt-test-418715-4b9278f2d459.json'))}');
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
            text: content! + '(${emotionResult})',
          );
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
      await check(audioPath).then((value) => emotionResult= value).whenComplete(() {
        if(emotionResult.isEmpty == false) setState(() {});
        transcribe();
      });
    } catch (e) {
      print('Error Stopping record : $e');
      print('정지 에러');
    }
  }

  // Future<void> playRecording() async {
  //   try {
  //     audio_players.Source urlSource = audio_players.UrlSource(audioPath);
  //     print(urlSource);
  //     await audioPlay.play(urlSource);
  //   } catch (e) {
  //     print('Error playing Record : $e');
  //   }
  // }

  //나중에 매개변수를 클래스로 만들면 좋을 것 같음, 현재는 테스트용
  //Clova Api 연결, 문자, 감정, 감정의 강도, 음색
  Future<Uint8List> clovaTTS(String text, int volume, int emotion, int emotionStrength, int alpha) async {
    //키 값
    final String clientId = 'ahwedxouv8';
    final String clientSecret = 'n2I4W3NoWC6fOTEopeEF0wo8SotsJbKSXIYanpL2';
    final String url = 'https://naveropenapi.apigw.ntruss.com/tts-premium/v1/tts';

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

  Future<void> _playAudio(String text, int volume, int emotion, int emotionStrength, int alpha) async {
    //tts 결과를 반환, 데이터 타입 -> Uint8List
    final voice =
    await clovaTTS(text, volume, emotion, emotionStrength, alpha);

    // 임시 파일로 변환하여 재생
    final tempFile = File('${Directory.systemTemp.path}/clova.mp3');
    await tempFile.writeAsBytes(voice);
    print('임시 파일 경로: $tempFile');

    await audioPlayer.setFilePath(tempFile.path);
    await audioPlayer.play();
  }

  //api 테스트

  Future<String> apiTest(String fileTest) async {
    //바로 넘겨줄 때
    ByteData data = await rootBundle.load(fileTest);
    List<int> voiceData = data.buffer.asUint8List();

    //로컬에서 넘겨줄 때
    // File file = File(fileTest);
    // List<int> voiceData = await file.readAsBytes();

    var request = http.MultipartRequest('POST', Uri.parse('$ip/tt'));
    request.files.add(http.MultipartFile.fromBytes('fileTest', voiceData, filename: 'check4.wav'));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      String errorMessage = response.body;
      throw Exception(errorMessage);
    }
  }
  //ai 모델
  Future<String> check(String fileTest) async {
    File file = File(fileTest);
    List<int> voiceData = await file.readAsBytes();

    // ByteData data = await rootBundle.load(fileTest);
    // List<int> voiceData = data.buffer.asUint8List();

    var request = http.MultipartRequest('POST', Uri.parse('$ip/Send_Message_Dairy/model'));
    print('요청:${request}');
    request.files.add(http.MultipartFile.fromBytes('fileTest', voiceData, filename: 'emotion.wav',));

    var streamedResponse = await request.send();
    print('보냈지?:$streamedResponse');
    var response = await http.Response.fromStream(streamedResponse);
    print('결과:${response.body}');

    if (response.statusCode == 200) {
      print('체크 성공적');
      return response.body;
    } else {
      String errorMessage = response.body;
      throw Exception(errorMessage);
    }
  }


  final _openAI = OpenAI.instance.build(
    token: dotenv.env['OPENAI_API_KEY'],
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );

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
            child: const Text('일기 작성', style: TextStyle(
              color: Colors.black,
            ),),
          ),
          keyboardMode ?? false
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      keyboardMode = false;
                    });
                  }, icon: const Icon(Icons.mic_none_outlined),)
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
            hintText: keyboardMode ==false ? "위의 마이크로 나에게 너의 감정을 들려줘!" : '키보드 모드 활성화 되었습니다.',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(24),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        messages: _messages,
      ),
      floatingActionButton: keyboardMode == false ?  Align(
        alignment: const Alignment(0,0.99),
        child: FloatingActionButton(
          onPressed: () => isRecording ? stopRecording() : startRecording(),
          backgroundColor: isRecording? Colors.red : const Color.fromRGBO(0, 166, 126, 1),
          child: const Icon(Icons.mic_none_outlined,size: 24),
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat  ,
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });

    List<Map<String, dynamic>> messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return {
          'role': 'user',
          'content': m.text,
        };
      } else {
        return {
          'role': 'assistant',
          'content': m.text,
        };
      }
    }).toList();
    final request = ChatCompleteText(
      model: GptTurboChatModel(),
      messages: messagesHistory,
      maxToken: 200,
    );
    final resp = await _openAI.onChatCompletion(request: request);

    for (var element in resp!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _gptChatUser,
              createdAt: DateTime.now(),
              text: element.message!.content,
            ),
          );
          // _playAudio(element.message!.content, 5, 1, 2, 0);
        });
      }
    }
    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }
}