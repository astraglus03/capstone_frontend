import 'dart:convert';
import 'dart:io';
import 'package:capstone_frontend/const/api_utils.dart';
import 'package:capstone_frontend/screen/statistic/model/currentuser_model.dart';
import 'package:capstone_frontend/screen/statistic/model/chat_create_diary_model.dart';
import 'package:capstone_frontend/screen/statistic/model/chat_resp_model.dart';
import 'package:capstone_frontend/screen/statistic/model/chat_send_model.dart';
import 'package:capstone_frontend/screen/main_screen.dart';
import 'package:capstone_frontend/screen/statistic/model/chat_threadid_model.dart';
import 'package:capstone_frontend/screen/statistic/model/weight_resp_model.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:google_speech/google_speech.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class SampleAudioScreen extends StatefulWidget {
  const SampleAudioScreen({Key? key}) : super(key: key);

  @override
  State<SampleAudioScreen> createState() => _SampleAudioScreenState();
}

class _SampleAudioScreenState extends State<SampleAudioScreen> {
  bool isRecord = false;
  final dio = Dio();
  final userId = UserManager().getUserId();
  late FlutterSoundRecorder audioRecord;
  late audio_players.AudioPlayer audioPlay;
  late String audioPath;
  int currentRecordIndex = 0;
  List<File> voices = [];
  final List<String> sentences = [
    "오늘 달리기 대회에서 1등 했어!",
    "친구가 맛있는거 사줘서 기분이 좋아!",
    "부모님이 생일선물로 자전거를 선물해줬어",
    "오늘은 친구들과 함께 놀이공원에 갔어!",
    "퐁당이 어플을 만나서 행복해."
  ];

  @override
  void initState() {
    audioPlay = audio_players.AudioPlayer();
    audioRecord = FlutterSoundRecorder();
    audioPath = '';
    setPermissions();
    super.initState();
  }

  @override
  void dispose() {
    audioPlay.dispose();
    super.dispose();
  }

  void setPermissions() async {
    try {
      await Permission.microphone.request();
      print("마이크 permission 성공");
    } catch (e) {
      print("마이크 permission 실패: $e");
    }

    try {
      await Permission.manageExternalStorage.request();
      print("외부 저장소 permission 성공");
    } catch (e) {
      print("외부 저장소 permission 실패: $e");
    }

    try {
      await Permission.storage.request();
      print("저장소 permission 성공");
    } catch (e) {
      print("저장소 permission 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: CustomAppBar(),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
              child: Text(
            '여러분의 행복한 목소리로 감정을',
            style: TextStyle(
              fontSize: 20,
            ),
          )),
          Center(
              child: Text(
            '더욱더 잘 이해할 수 있어요!(한번만 진행)',
            style: TextStyle(
              fontSize: 20,
            ),
          )),
          SizedBox(
            height: 20,
          ),
          ...sentences.asMap().entries.map((entry) {
            int index = entry.key;
            String sentence = entry.value;
            return ListTile(
              title: Text(
                sentence,
                style: TextStyle(fontSize: 14),
              ),
              trailing: currentRecordIndex == index
                  ? IconButton(
                      icon: Icon(isRecord ? Icons.stop : Icons.mic),
                      onPressed: isRecord ? stopRecording : startRecording,
                    )
                  : SizedBox.shrink(),
            );
          }).toList(),
          if (voices.length == 5)
            ElevatedButton(
              onPressed: () async {
                await getWeight(userId!, voices[0], voices[1], voices[2], voices[3], voices[4]);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => MainScreen()));
              },
              child: Text('완료하기'),
            ),
        ],
      ),
    );
  }

  Future<void> getCurrentWeight(String userId) async {
    try {
      final resp = await dio.get('$ip/userinfo/userinfo/$userId');

      if (resp.statusCode == 200) {
        return resp.data['weight'];
      } else {
        throw Exception('서버에서 정보를 가져오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  Future<void> startRecording() async {
    try {
      String tempDir = (await getTemporaryDirectory()).path;
      print(tempDir);
      audioPath = tempDir + '/' + Uuid().v4() + '.wav';
      await audioRecord.openRecorder();
      await audioRecord.startRecorder(toFile: audioPath);
      setState(() {
        isRecord = true;
      });
      print('녹음 시작, 경로: $audioPath');
    } catch (e) {
      print('Error Start Recording : $e');
      print('시작 에러');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stopRecorder();

      setState(() {
        isRecord = false;
        currentRecordIndex++;
      });
      await audioRecord.closeRecorder();
      File file = File(audioPath);
      voices.add(file);
      print('녹음기가 정상적으로 닫혔습니다.');
    } catch (e) {
      print('녹음 중지 중 오류 발생: $e');
    }
  }

  Future<String> getWeight(String userId, File voice1, File voice2, File voice3, File voice4, File voice5) async {
    FormData formData = FormData.fromMap({
      'userid': userId,
      'file1': await MultipartFile.fromFile(voice1.path, filename: 'voice1.wav'),
      'file2': await MultipartFile.fromFile(voice2.path, filename: 'voice2.wav'),
      'file3': await MultipartFile.fromFile(voice3.path, filename: 'voice3.wav'),
      'file4': await MultipartFile.fromFile(voice4.path, filename: 'voice4.wav'),
      'file5': await MultipartFile.fromFile(voice5.path, filename: 'voice5.wav'),
    });

    final resp = await dio.post('$ip/set_weight_api/weight', data: formData);

    if (resp.statusCode == 200) {
      return '전송 성공';
    } else {
      throw Exception('서버에서 정보를 가져오는 데 실패했습니다.');
    }
  }
}

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AppBarClipper(),
      child: Container(
        color: Color(0xFFC9F5FF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                Image.asset('asset/logo.jpeg', scale: 10),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 40);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height - 60, size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
