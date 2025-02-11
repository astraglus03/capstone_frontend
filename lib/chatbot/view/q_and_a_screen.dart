// import 'dart:io';
// import 'package:capstone_frontend/chatbot/models/chat_threadid_model.dart';
// import 'package:capstone_frontend/chatbot/models/q_and_a_resp_model.dart';
// import 'package:capstone_frontend/chatbot/models/q_and_a_send_model.dart';
// import 'package:capstone_frontend/common/const/const.dart';
// import 'package:capstone_frontend/user/social_api/auth_api.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:audioplayers/audioplayers.dart' as audio_players;
// import 'package:just_audio/just_audio.dart' as just_audio;
// import 'package:google_speech/google_speech.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
//
// class QandAScreen extends StatefulWidget {
//   const QandAScreen({Key? key}) : super(key: key);
//
//   @override
//   State<QandAScreen> createState() => _QandAScreenState();
// }
//
// class _QandAScreenState extends State<QandAScreen> {
//
//   final dio = Dio();
//   //음성 녹음
//   late FlutterSoundRecorder audioRecord;
//   late audio_players.AudioPlayer audioPlay;
//   late String audioPath;
//   String? content = '';
//   bool keyboardMode = false;
//   bool isRecording = false;
//   bool is_Transcribing = false;
//   just_audio.AudioPlayer audioPlayer = just_audio.AudioPlayer();
//   String threadId = '';
//   String message = '';
//   String answer = '';
//   late ChatUser _currentUser = ChatUser(id: '1', firstName: '', lastName: '');
//
//   final ChatUser _gptChatUser =
//   ChatUser(id: '2', firstName: '퐁', lastName: '당');
//
//   final List<ChatMessage> _messages = <ChatMessage>[];
//   final List<ChatUser> _typingUsers = <ChatUser>[];
//
//   @override
//   void initState() {
//     audioPlay = audio_players.AudioPlayer();
//     audioRecord = FlutterSoundRecorder();
//     createChatThread(UserManager().getUserId()!);
//     // getCurrentUser(UserManager().getUserId().toString());
//     audioPath = '';
//     setPermissions();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     audioPlay.dispose();
//     super.dispose();
//   }
//
//   // Future<CurrentUser?> getCurrentUser(String userId) async {
//   //   try {
//   //     final resp = await dio.get('$ip/userinfo/userinfo/$userId');
//   //
//   //     if (resp.statusCode == 200) {
//   //       setState(() {
//   //         _currentUser = ChatUser(
//   //           id: '1',
//   //           firstName: resp.data['nickname'].substring(0, 1),
//   //           lastName: resp.data['nickname'].substring(1),
//   //           profileImage: resp.data['profileImage'],
//   //         );
//   //       });
//   //       return CurrentUser.fromJson(resp.data);
//   //       // print("사용자 ID: ${data['userId']}");
//   //       // print("닉네임: ${data['nickname']}");
//   //       // print("프로필 이미지 URL: ${data['profileImage']}");
//   //     } else {
//   //       throw Exception('서버에서 정보를 가져오는 데 실패했습니다.');
//   //     }
//   //   } catch (e) {
//   //     print('에러 발생: $e');
//   //   }
//   // }
//
//   void setPermissions() async {
//     await Permission.microphone.request();
//     await Permission.manageExternalStorage.request();
//     await Permission.storage.request();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(150.0),
//         child: CustomAppBar(
//           keyboardMode: keyboardMode,
//           onToggleKeyboardMode: () {
//             // Function to toggle keyboard mode
//             setState(() {
//               keyboardMode = !keyboardMode;
//             });
//           },
//         ),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               // image: DecorationImage(
//               //   image: AssetImage("asset/chat_img.png"), // Replace with your image path
//               //   fit: BoxFit.cover,
//               // ),
//               //color: Color(0xFFC9F5FF),
//             ),
//           ),
//           DashChat(
//             messageOptions: const MessageOptions(
//               showCurrentUserAvatar: true,
//               currentUserContainerColor: Colors.lightBlueAccent,
//               containerColor: Colors.white,
//               textColor: Colors.black,
//             ),
//             currentUser: _currentUser,
//             typingUsers: _typingUsers,
//             onSend: (ChatMessage m) {
//               getChatResponse(m);
//             },
//             inputOptions: InputOptions(
//               sendOnEnter: true,
//               inputDisabled: true,
//               inputDecoration: InputDecoration(),
//             ),
//             messages: _messages,
//           ),
//         ],
//       ),
//       floatingActionButton: keyboardMode == false
//           ? Align(
//         alignment: const Alignment(0, 0.99),
//         child: FloatingActionButton(
//           onPressed: () {
//             isRecording ? stopRecording() : startRecording();
//           },
//           backgroundColor: isRecording ? Color(0xFFF15F5F) : Color(0xFFE0FFDB),
//           child: const Icon(Icons.mic_none_outlined, size: 24),
//         ),
//       )
//           : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//
//   Future<void> transcribe() async {
//     setState(() {
//       is_Transcribing = true;
//     });
//     final serviceAccount = ServiceAccount.fromString('${(await rootBundle.loadString('asset/stt-test-418715-4b9278f2d459.json'))}');
//     final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
//     final config = RecognitionConfig(
//         encoding: AudioEncoding.LINEAR16,
//         model: RecognitionModel.basic,
//         enableAutomaticPunctuation: true,
//         sampleRateHertz: 16000,
//         audioChannelCount: 1,
//         languageCode: 'ko-KR'
//     );
//     final audio = await _getAudioContent(audioPath);
//     // print(audioPath);
//     await speechToText.recognize(config, audio).then((value) {
//       // print(value.results);
//       if (value.results.isNotEmpty) {
//         setState(() {
//           _typingUsers.remove(_currentUser);
//           content = value.results.map((e) => e.alternatives.first.transcript).join('\n');
//           print('음성 인식 결과: $content');
//           ChatMessage message = ChatMessage(
//             user: _currentUser,
//             createdAt: DateTime.now(),
//             text: content!,
//           );
//           getChatResponse(message);
//         });
//       }
//       else {
//         setState(() {
//           content = '음성 인식 결과가 없습니다. 다시 시도해주세요.';
//         });
//         print('No results found');
//       }
//     }).catchError((error) {
//       setState(() {
//         content = '음성 인식 중 오류가 발생했습니다: $error';
//       });
//     }).whenComplete(() {
//       setState(() {
//         is_Transcribing = false;
//         print('출력 완료');
//       });
//     });
//   }
//
//   Future<List<int>> _getAudioContent(filePath) async {
//     //로컬 디렉토리 파일을 넘겨주기 위해서는 이 방법을 해야함.
//     File file = File(filePath);
//     List<int> voiceData = await file.readAsBytes();
//     return voiceData;
//   }
//
//   Future<void> startRecording() async {
//     try {
//       String tempDir = (await getTemporaryDirectory()).path;
//       audioPath = '$tempDir/recording.wav'; // 저장할 파일 경로
//       await audioRecord.openRecorder();
//       await audioRecord.startRecorder(toFile: audioPath);
//       setState(() {
//         isRecording = true;
//         _typingUsers.add(_currentUser);
//       });
//       print('녹음 시작, 경로: $audioPath');
//     } catch (e) {
//       print('Error Start Recording : $e');
//       print('시작 에러');
//     }
//   }
//
//   Future<void> stopRecording() async {
//     try {
//       String? path = await audioRecord.stopRecorder();
//
//       setState(() {
//         isRecording = false;
//       });
//       await audioRecord.closeRecorder();
//       print('녹음기가 정상적으로 닫혔습니다.');
//
//       await transcribe();
//     } catch (e) {
//       print('녹음 중지 중 오류 발생: $e');
//     }
//   }
//
//
//   //Clova Api 연결, 문자, 감정, 감정의 강도, 음색
//   Future<Uint8List> clovaTTS(String text, int emotion, int volume,  int emotionStrength, int alpha, int speed) async {
//     //키 값
//     const String clientId = '574nlmj8za';
//     const String clientSecret = 'pS4OXOd0H1AqPKUeLabIqlVwMv8VJZCCuynxstAe';
//     const String url = 'https://naveropenapi.apigw.ntruss.com/tts-premium/v1/tts';
//
//     //헤더
//     Map<String, String> headers = {
//       'Content-Type': 'application/x-www-form-urlencoded',
//       'X-NCP-APIGW-API-KEY-ID': clientId,
//       'X-NCP-APIGW-API-KEY': clientSecret,
//     };
//
//     //요청 정보
//     Map<String, String> body = {
//       'speaker': 'vara',
//       //목소리 종류
//       'speed': '0',
//       //속도, -5~5 (낮으면 빠름)
//       'text': text,
//       //문장
//       'volume': volume.toString(),
//       //음성 볼륨, -5~5 (클수록 큼)
//       'emotion': emotion.toString(),
//       //음성 감정, 0~3(중립, 슬픔, 기쁨, 분노)
//       'emotion-strength': emotionStrength.toString(),
//       // 감정의 강도, 0~2(약함, 보통, 강함)
//       'alpha': alpha.toString()
//       // 음색, -5~5 (높을수록 높음)
//     };
//
//     //http post 요청
//     final response = await http.post(Uri.parse(url), headers: headers, body: body);
//
//     if (response.statusCode == 200) {
//       return response.bodyBytes;
//     } else {
//       String errorMessage = response.body;
//       throw Exception(errorMessage);
//     }
//   }
//
//   Future<void> _playAudio(String text, int emotion, int volume, int emotionStrength, int alpha, int speed) async {
//     //tts 결과를 반환, 데이터 타입 -> Uint8List
//     final voice = await clovaTTS(text, emotion, volume, emotionStrength, alpha, speed);
//
//     // 임시 파일로 변환하여 재생
//     final tempFile = File('${Directory.systemTemp.path}/clova.mp3');
//     await tempFile.writeAsBytes(voice);
//     print('임시 파일 경로: $tempFile');
//
//     audioPlayer.setFilePath(tempFile.path);
//     audioPlayer.play();
//   }
//
//   Future<ChatThreadIdModel> createChatThread(String userId) async {
//
//     final resp = await dio.post('$ip/Create_Chatroom/chatroom', data: {
//       'userId': userId,
//     });
//
//     if (resp.statusCode == 200) {
//       final data = resp.data;
//       ChatThreadIdModel chatThreadId = ChatThreadIdModel.fromJson(data);
//       setState(() {
//         threadId = chatThreadId.threadId;
//         print('threadid: $threadId');
//       });
//       return chatThreadId;
//     } else if (resp.statusCode == 400) {
//       final data = resp.data;
//       throw Exception('Error: ${data['message']}');
//     } else {
//       throw Exception('Failed to connect to the server');
//     }
//   }
//
//   Future<QandARespModel?> sendQandAMessage(QandASendModel model) async {
//     final resp = await dio.post('$ip/Search_gpt_api/searchgpt', data: {
//       'userId': model.userId,
//       'threadId': model.threadId,
//       'text': model.text,
//     });
//
//     if (resp.statusCode == 200) {
//       // print(data);
//       QandARespModel respModel = QandARespModel.fromJson(resp.data);
//       setState(() {
//         answer = respModel.answer;
//       });
//       return respModel;
//     }
//   }
//
//   Future<void> getChatResponse(ChatMessage m) async {
//     setState(() {
//       _messages.insert(0, m);
//       _typingUsers.add(_gptChatUser);
//     });
//     QandASendModel sendModel = QandASendModel(
//       userId: UserManager().getUserId()!,
//       threadId: threadId,
//       text: m.text,
//     );
//
//     // API 호출을 통해 서버로부터 응답을 받습니다.
//     await sendQandAMessage(sendModel);  // await을 추가하여 응답을 기다림
//
//     setState(() {
//       _messages.insert(0,
//         ChatMessage(
//           user: _gptChatUser,
//           createdAt: DateTime.now(),
//           text: answer,
//         ),
//       );
//       _typingUsers.remove(_gptChatUser);
//     });
//
//     _playAudio(answer, 0, 5, 2, 0, -3);  // volume, emotionStrength, alpha, speed
//   }
// }
//
// class CustomAppBar extends StatefulWidget {
//   final bool keyboardMode;
//   final VoidCallback onToggleKeyboardMode;
//
//   const CustomAppBar({
//     required this.keyboardMode,
//     required this.onToggleKeyboardMode,
//   });
//
//   @override
//   _CustomAppBarState createState() => _CustomAppBarState();
// }
//
// class _CustomAppBarState extends State<CustomAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: AppBarClipper(),
//       child: Container(
//         color: Color(0xFFE0FFDB),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Navigate back when the icon is pressed
//                   },
//                 ),
//                 Spacer(),
//                 CircleAvatar(
//                   backgroundImage: AssetImage('asset/logo.jpeg'),
//                   radius: 24,
//                 ),
//                 Spacer(),
//
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       widget.onToggleKeyboardMode();
//                     });
//                   },
//                   icon: Icon(widget.keyboardMode ? Icons.mic_none_outlined : Icons.keyboard_alt_outlined),
//                   color: Colors.black,
//                 ),
//               ],
//             ),
//             Text(
//               '떠올리고싶은걸 물어봐!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AppBarClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, size.height - 40);
//     path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height - 40);
//     path.quadraticBezierTo(size.width * 3 / 4, size.height - 60, size.width, size.height - 10);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }