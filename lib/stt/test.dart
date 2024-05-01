import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterSoundRecorder audioRecord = FlutterSoundRecorder();
  final stt.SpeechToText speech = stt.SpeechToText();

  bool isRecording = false;
  String audioPath = '';
  String result = '';
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void dispose() {
    audioRecord.closeRecorder();
    super.dispose();
  }

  Future<void> startRecordingWithSTT() async {
    try {
      audioPath = '';
      await audioRecord.openRecorder();
      await audioRecord.startRecorder(toFile: 'audio.aac');
      setState(() {
        isRecording = true;
        print('음성기록시작');
      });
      bool available = await speech.initialize();
      if (available) {
        await speech.listen(
          onResult: (result) {

            setState(() {
              this.result = result.recognizedWords;
            });
            print('Speech recognition result: ${result.recognizedWords}');
          },
        );
      } else {
        print('Speech recognition not available');
      }
    } catch (e) {
      print('Error starting recording with STT: $e');
    }
  }

  Future<void> stopRecordingWithSTT() async {

    String? path = await audioRecord.stopRecorder();
    try {
      setState(() {
        isRecording = false;
        print('음성기록중지');
        audioPath = path!;
      });
      await speech.stop();
    } catch (e) {
      print('Error stopping recording with STT: $e');
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
      print('음성기록재생: $audioPath');
    } catch (e) {
      print('Error playing Recording : $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STT Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed:
              isRecording ? stopRecordingWithSTT : startRecordingWithSTT,
              child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: playRecording,
              child: Text('Play Recording'),
            ),

            Text('변환된 텍스트:$result')
          ],
        ),
      ),
    );
  }
}
