import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart' as audio_players;

class Clova extends StatefulWidget {
  const Clova({super.key});

  @override
  State<Clova> createState() => _ClovaState();
}

class _ClovaState extends State<Clova> {
  just_audio.AudioPlayer audioPlayer = just_audio.AudioPlayer();

  //나중에 매개변수를 클래스로 만들면 좋을 것 같음, 현재는 테스트용
  //Clova Api 연결, 문자, 감정, 감정의 강도, 음색
  Future<Uint8List> clovaTTS(String text, int volume, int emotion, int emotion_strength, int alpha) async {
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
      'emotion-strength': emotion_strength.toString(),
      // 감정의 강도, 0~2(약함, 보통, 강함)
      'alpha': alpha.toString()
      // 음색, -5~5 (높을수록 높음)
    };

    //http post 요청
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      String errorMessage = response.body;
      throw Exception(errorMessage);
    }
  }

  Future<void> _playAudio(String text, int volume, int emotion,
      int emotion_strength, int alpha) async {
    //tts 결과를 반환, 데이터 타입 -> Uint8List
    final voice =
        await clovaTTS(text, volume, emotion, emotion_strength, alpha);

    // 임시 파일로 변환하여 재생
    final tempFile = File('${Directory.systemTemp.path}/clova.mp3');
    await tempFile.writeAsBytes(voice);
    print('임시 파일 경로: $tempFile');

    await audioPlayer.setFilePath(tempFile.path);
    await audioPlayer.play();
  }


  //STT
  Future<String> clovaSTT(String filePath) async {
    final String language = 'Kor';
    final String clientId = 'ahwedxouv8';
    final String clientSecret = 'n2I4W3NoWC6fOTEopeEF0wo8SotsJbKSXIYanpL2';
    final String url = 'https://naveropenapi.apigw.ntruss.com/recog/v1/stt?lang=$language';


    // 파일을 바이너리로 읽어오기, Naver CSR은 바이너리 음성 데이터가 필요함
    ByteData data = await rootBundle.load(filePath);
    List<int> voiceData = data.buffer.asUint8List();
    //print(voiceData);

    //로컬 디렉토리 파일을 넘겨주기 위해서는 이 방법을 해야함.
    // File file = File(filePath);
    // List<int> voiceData = await file.readAsBytes();

    //헤더
    Map<String, String> headers = {
      'Content-Type': 'application/octet-stream',
      'X-NCP-APIGW-API-KEY-ID': clientId,
      'X-NCP-APIGW-API-KEY': clientSecret,
    };

    final response = await http.post(Uri.parse(url), headers: headers, body: voiceData);

    if (response.statusCode == 200) {
      stt = response.body;
      return response.body;
    } else {
      String errorMessage = response.body;
      throw Exception(errorMessage);
    }
  }

  //음성 녹음
  late FlutterSoundRecorder audioRecord;
  late audio_players.AudioPlayer audioPlay;
  bool isRecording = false;
  String audioPath = '';
  String stt = '';

  @override
  void initState() {
    audioPlay = audio_players.AudioPlayer();
    audioRecord = FlutterSoundRecorder();
    super.initState();
  }

  @override
  void dispose() {
    audioPlay.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      await audioRecord.openRecorder();
      await audioRecord.startRecorder(toFile: 'audio.aac');
      setState(() {
        isRecording = true;
      });
    } catch (e) {
      print('Error Start Recording : $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stopRecorder();
      print(path);
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
      await audioRecord.closeRecorder();
      String voiceText = await clovaSTT(audioPath);
      // print(voiceText);
      setState(() {
        stt = voiceText;
      });
    } catch (e) {
      print('Error Stopping record : $e');
    }
  }

  Future<void> playRecording() async {
    try {
      audio_players.Source urlSource = audio_players.UrlSource(audioPath);
      print(urlSource);
      await audioPlay.play(urlSource);
    } catch (e) {
      print('Eroor playing Record : $e');
    }
  }

  //api 테스트
  final gServerIp = 'http://192.168.0.6:5000/';
  String result = '0';

  Future<String> apiTest(String fileTest) async {
    File file = File(fileTest);
    List<int> voiceData = await file.readAsBytes();

    String addr = gServerIp + 'tt';

    var request = http.MultipartRequest('POST', Uri.parse(addr));
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

    String addr = gServerIp + 'model';

    var request = http.MultipartRequest('POST', Uri.parse(addr));
    request.files.add(http.MultipartFile.fromBytes('fileTest', voiceData, filename: 'emotion.wav'));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      String errorMessage = response.body;
      throw Exception(errorMessage);
    }
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Naver API TEST'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                _playAudio('너 지금 뭐해?', 5, 1, 2,
                    0); //text, volume, emotion, emotion_strength, alpha
              },
              child: Text('tts'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                String voiceText = await clovaSTT('asset/wav/check2t.wav');
                print(voiceText);
              },
              child: Text('stt'),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          if (isRecording)
            const Text(
              'Recording',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          SizedBox(
            height: 25,
          ),
          Center(
            child: ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child: isRecording
                  ? const Text('Stop Recording')
                  : const Text('Start Recording'),
            ),
          ),
          if (!isRecording && audioPath != null)
            ElevatedButton(
              onPressed: playRecording,
              child: Text('Play Recording'),
            ),
          ElevatedButton(
              onPressed: (){
                check(audioPath)
                    .then((value) => result = value)
                    .whenComplete(() {
                      if(result.isEmpty == false) setState(() {});
                });
              },
              child: Text('피치 분석')
          ),
          Expanded(child: Text(result)),
          Expanded(child: Text(stt)),
        ],
      ),
    );
  }
}
