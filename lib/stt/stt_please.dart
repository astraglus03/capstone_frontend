import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';


class FinalStt extends StatefulWidget {
  FinalStt({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FinalSttState createState() => _FinalSttState();
}

class _FinalSttState extends State<FinalStt> {
  bool is_Transcribing = false;
  String content = '';

  Future<void> transcribe() async {
    setState(() {
      is_Transcribing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        (await rootBundle.loadString('assets/stt-test-418715-4b9278f2d459.json'))); // json 파일
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);

    final config = RecognitionConfig(
      //encoding: AudioEncoding.LINEAR16,
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 16000,
        audioChannelCount: 1,
        languageCode: 'ko-KR');

    final audio = await _getAudioContent(audioPath);
    await speechToText.recognize(config, audio).then((value) {
      setState(() {
        content = value.results.map((e) => e.alternatives.first.transcript).join('\n');
        print(content);
      });


      if (value.results.isNotEmpty) {
        setState(() {
          content = value.results.map((e) => e.alternatives.first.transcript).join('\n');
          print(content);
        });
      } else {
        print('No results found');
      }
    }).whenComplete(() {
      setState(() {
        is_Transcribing = false;
        print('출력 완료');
      });
    });
  }

  Future<List<int>> _getAudioContent(filePath) async {
    //final directory = await getApplicationDocumentsDirectory();
    //final path = directory.path + '/$name';
    // final path = 'asset/wav/check.mp3';
    // return File(path).readAsBytesSync().toList();
    // final ByteData data = await rootBundle.load(filePath);
    // return data.buffer.asUint8List();

    //로컬 디렉토리 파일을 넘겨주기 위해서는 이 방법을 해야함.
    File file = File(filePath);
    List<int> voiceData = await file.readAsBytes();
    return voiceData;
  }

  //음성 녹음
  late FlutterSoundRecorder audioRecord;
  late audio_players.AudioPlayer audioPlay;
  bool isRecording = false;
  late String audioPath;

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
      print('Error Start Recording : $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stopRecorder();
      print(path);
      setState(() {
        isRecording = false;
      });
      await audioRecord.closeRecorder();
      // String voiceText = await clovaSTT(audioPath);
      // print(voiceText);
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
    ByteData data = await rootBundle.load(fileTest);
    List<int> voiceData = data.buffer.asUint8List();

    // File file = File(fileTest);
    // List<int> voiceData = await file.readAsBytes();

    String addr = '${gServerIp}tt';

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

  @override
  void initState() {
    audioPlay = audio_players.AudioPlayer();
    audioRecord = FlutterSoundRecorder();
    audioPath='';
    setPermissions();
    super.initState();
  }

  @override
  void dispose() {
    audioPlay.dispose();
    super.dispose();
  }

  void setPermissions() async {
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 108, 96, 225),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color.fromARGB(255, 108, 96, 225),
        elevation: 0,
        centerTitle: true,
        title: const Text('Transcribe Your Audio'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 70,
                ),
                Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: content == ''
                      ? const Text(
                    'Your text will appear here',
                    style: TextStyle(color: Colors.grey),
                  )
                      : Text(
                    content,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: is_Transcribing
                      ? const Expanded(
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballPulse,
                      colors: [Colors.red, Colors.green, Colors.blue],
                    ),
                  )
                      :ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      //primary: Color.fromARGB(255, 108, 96, 225), // 버튼의 배경색 지정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: is_Transcribing ? () {} : transcribe,
                    child: is_Transcribing
                        ? const CircularProgressIndicator()
                        : const Text(
                      'Transcribe',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isRecording ? stopRecording : startRecording,
                      child: isRecording
                          ? const Text('Stop Recording')
                          : const Text('Start Recording'),
                    ),
                    if (!isRecording && audioPath != null)
                      ElevatedButton(
                        onPressed: playRecording,
                        child: const Text('Play Recording'),
                      ),
                    ElevatedButton(
                      onPressed: (){
                        apiTest('asset/wav/check2.mp3')
                            .then((value) => result = value)
                            .whenComplete(() {
                          if(result.isEmpty == false) setState(() {});
                        });
                      },
                      child: const Text('피치분석'),
                    ),
                    Text(result),
                    //Expanded(child: Text(result)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}