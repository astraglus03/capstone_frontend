import 'package:capstone_frontend/calendar/view/calendar.dart';
import 'package:capstone_frontend/common/component/default_sliver_padding.dart';
import 'package:capstone_frontend/common/const/const.dart';
import 'package:capstone_frontend/home/diary_detail_screen.dart';
import 'package:capstone_frontend/home/models/diary_model.dart';
import 'package:capstone_frontend/home/models/month_emotion_resp_model.dart';
import 'package:capstone_frontend/statistic/view/photoDetailScreen.dart';
import 'package:capstone_frontend/statistic/view/pie_chart_case.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  late Future<List<DiaryMonthModel>> _emotionFuture;
  final TextEditingController memoController = TextEditingController();
  final TextEditingController assistantController = TextEditingController();
  final FocusNode memoFocusNode = FocusNode();
  final FocusNode assistantFocusNode = FocusNode();
  final bool _isFocused = false; // 메모란에 포커스 여부
  // final viewmodel = MainViewModel(KakaoLogin());
  // String? userId = UserManager().getUserId();
  final String limit = '2';
  final dio = Dio();
  String feedback = '';
  String repEmo = '';
  List emotionList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
            ],
          )),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/basebackground.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: CustomScrollView(
              slivers: [
                // _diaryInfoSliver(),
                // _photoSliver(context),
                // _emotionSliver(),
                _piechartSliver(),
                _feedbackSliver(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // _emotionFuture = sendDiaryToBackend(UserManager().getUserId().toString(), DateFormat('yyyy-MM').format(DateTime.now()));
    // _emotionFuture.then((data) {
    //   final data1 = data[0].eventCount;
    //   // print(data1);
    //   int total = data1.reduce((a, b) => a + b);
    //   List labels = [
    //     'netural',
    //     'sad',
    //     'happy',
    //     'angry',
    //     'embrassed',
    //     'anxiety',
    //     'hurt'
    //   ];
    //   for (int i = 0; i < data1.length; i++) {
    //     double percentage = (data1[i] / total) * 100;
    //     emotionList.add('${labels[i]} ${percentage.toStringAsFixed(1)}%');
    //   }
    //   Provider.of<EmotionManager>(context, listen: false)
    //       .setRepEmo(emotionList);
    //   memoFocusNode.addListener(() {
    //     setState(() {
    //       _isFocused = memoFocusNode.hasFocus; // Update the focus status
    //     });
    //   });
    // });
  }

  @override
  void dispose() {
    memoController.dispose();
    assistantController.dispose();
    memoFocusNode.dispose();
    assistantFocusNode.dispose();
    super.dispose();
  }

  // 메모 수정 후 저장
  void _saveText() {
    print('Memo Saved: ${memoController.text}');
    memoFocusNode.unfocus(); // 포커스 해제
  }

  // Future<CurrentUser?> checkCurrentUser(String userId) async {
  //   try {
  //     final resp = await dio.get('$ip/userinfo/userinfo/$userId');
  //
  //     if (resp.statusCode == 200) {
  //       return CurrentUser.fromJson(resp.data);
  //       // print("사용자 ID: ${data['userId']}");
  //       // print("닉네임: ${data['nickname']}");
  //       // print("프로필 이미지 URL: ${data['profileImage']}");
  //     } else {
  //       throw Exception('서버에서 정보를 가져오는 데 실패했습니다.');
  //     }
  //   } catch (e) {
  //     print('에러 발생: $e');
  //   }
  //   return null;
  // }

  // DefaultSliverContainer _diaryInfoSliver() {
  //   return DefaultSliverContainer(
  //     height: 200,
  //     child: FutureBuilder<CurrentUser?>(
  //       future: checkCurrentUser(userId!),
  //       builder: (_, AsyncSnapshot<CurrentUser?> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return _buildloginskeletonUI();
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('데이터를 불러오는 중 에러가 발생했습니다.'));
  //         } else if (snapshot.hasData) {
  //           return Stack(
  //             children: [
  //               Row(
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(15.0),
  //                     child: CircleAvatar(
  //                       radius: 40,
  //                       backgroundImage: NetworkImage(snapshot.data!.imageUrl),
  //                       backgroundColor: Colors.grey[200],
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Text(
  //                               snapshot.data!.nickname,
  //                               style: TextStyle(
  //                                   fontSize: 20, fontWeight: FontWeight.bold),
  //                             ),
  //                             SizedBox(width: 10),
  //                             TextButton(
  //                               onPressed: () async {
  //                                 await viewmodel.logout();
  //                                 setState(() {
  //                                   // userId = '';
  //                                   // Navigator.pushReplacement(
  //                                   //     context,
  //                                   //     MaterialPageRoute(
  //                                   //         builder: (context) => AuthPage()));
  //                                 });
  //                               },
  //                               child: Text('로그아웃'),
  //                               style: TextButton.styleFrom(
  //                                 backgroundColor: Colors.blueGrey,
  //                                 foregroundColor: Colors.white,
  //                                 minimumSize: Size(30, 10),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(height: 15),
  //                         TextFormField(
  //                           controller: memoController,
  //                           focusNode: memoFocusNode,
  //                           decoration: InputDecoration(
  //                             labelText: '메모',
  //                             border: OutlineInputBorder(),
  //                             contentPadding: EdgeInsets.symmetric(
  //                                 vertical: 8, horizontal: 12),
  //                             isDense: true,
  //                           ),
  //                           style: TextStyle(fontSize: 14),
  //                         ),
  //                         if (_isFocused)
  //                           ElevatedButton(
  //                             onPressed: _saveText,
  //                             child: Text('저장하기'),
  //                           ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Positioned(
  //                 right: 5,
  //                 child: IconButton(
  //                   icon: const Icon(Icons.edit),
  //                   onPressed: () {
  //                     memoFocusNode.requestFocus();
  //                   },
  //                 ),
  //               ),
  //             ],
  //           );
  //         } else {
  //           return Center(
  //             child: Text('데이터가 없습니다.'),
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }

  Future<List<DiaryModel>> getPhoto(
      String userId, String date, String month, String limit) async {
    final resp = await dio.post('$ip/Search_Diary_api/searchdiary', data: {
      'userId': userId,
      'date': date,
      'month': month,
      'limit': limit,
    });
    if (resp.statusCode == 200) {
      // print('가져오기 성공');
      // print('가져오기${jsonData.map((item) => PhotoModel.fromJson(item)).toList()}');
      List<dynamic> data = resp.data;
      return data.reversed.map((e) => DiaryModel.fromJson(e)).toList();
    } else {
      print('Failed to load photo with status code: ${resp.statusCode}');
      print('Error body: ${resp.data}');
      throw Exception(
          'Failed to load photo with status code: ${resp.statusCode}');
    }
  }

  // DefaultSliverContainer _photoSliver(BuildContext context) {
  //   return DefaultSliverContainer(
  //     height: 200,
  //     child: FutureBuilder<List<DiaryModel>>(
  //       future: getPhoto(userId!, 'None', 'None', limit),
  //       builder: (_, AsyncSnapshot<List<DiaryModel>> snapshot) {
  //         if (snapshot.hasError) {
  //           print('여기부분${snapshot.error}');
  //           return Center(child: Text('데이터를 불러오는 중 에러가 발생했습니다.'));
  //         } else if (snapshot.connectionState == ConnectionState.waiting) {
  //           return _buildDiaryContainerUI();
  //         } else if (snapshot.hasData) {
  //           print(snapshot.data![1].small_emotion);
  //           return Row(
  //             children: [
  //               Expanded(
  //                 flex: 9,
  //                 child: ListView.builder(
  //                   scrollDirection: Axis.horizontal,
  //                   physics: NeverScrollableScrollPhysics(),
  //                   itemCount: snapshot.data!.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     return GestureDetector(
  //                       onTap: () {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => DiaryDetailScreen(
  //                               photoDetail: snapshot.data![index],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Image.memory(
  //                           snapshot.data![index].image!,
  //                           width: 150,
  //                           height: 150,
  //                           fit: BoxFit.cover,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               Expanded(
  //                   flex: 1,
  //                   child: TextButton(
  //                     onPressed: () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => PhotoDetailScreen(),
  //                         ),
  //                       );
  //                     },
  //                     child: Text('더보기'),
  //                   )),
  //             ],
  //           );
  //         } else {
  //           return Center(
  //             child: Text('데이터가 없습니다.'),
  //           ); // 데이터 없음 표시ƒ
  //         }
  //       },
  //     ),
  //   );
  // }

  DefaultSliverContainer _piechartSliver() {
    return DefaultSliverContainer(
      height: 400,
      child: FutureBuilder<List<DiaryMonthModel>>(
        future: _emotionFuture,
        builder: (_, AsyncSnapshot<List<DiaryMonthModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildGraphSkeletonUI();
          } else if (snapshot.hasData) {
            // print(snapshot.data!.length);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: '1개월',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'KCC-Ganpan'),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' 감정 변화 비율',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                PieChartCase(emotionList: snapshot.data![0].cases),
                SizedBox(
                  height: 30,
                ),
                Text(snapshot.data![0].sendComment),
                SizedBox(height: 20),
                TextFormField(
                  controller: assistantController,
                  focusNode: assistantFocusNode,
                  decoration: InputDecoration(
                    labelText: '메모',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: 14),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      // if (assistantController.text != null) {
                      //   await sendToAssistant(
                      //       userId!, assistantController.text);
                      //   assistantController.text = '';
                      //   assistantFocusNode.unfocus();
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         title: Text('전송 완료'),
                      //         content: Text('메모가 전송되었습니다.'),
                      //       );
                      //     },
                      //   );
                      //   Future.delayed(Duration(seconds: 1), () {
                      //     Navigator.of(context).pop();
                      //   });
                      // } else {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return AlertDialog(
                      //         title: Text('전송 실패'),
                      //         content: Text('입력하고 다시 시도해주세요.'),
                      //       );
                      //     },
                      //   );
                      //   Future.delayed(Duration(seconds: 1), () {
                      //     Navigator.of(context).pop();
                      //   });
                      // }
                    },
                    child: Text('전송하기'),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text('데이터가 없습니다'),
            );
          }
        },
      ),
    );
  }

  Future<void> sendToAssistant(String userId, String memo) async {
    final resp = await dio.post('$ip/user_feedback_api/userfeedback',
        data: {'userId': userId, 'content': memo});

    if (resp.statusCode == 200) {
      print(resp.data);
    }
  }

  // 한 달 감정 카운트 그래프
  Future<List<DiaryMonthModel>> sendDiaryToBackend(
      String userId, String month) async {
    try {
      final resp =
          await dio.post('$ip/Count_Month_Emotion/countmonthemotion', data: {
        'userId': userId,
        'month': month,
      });

      if (resp.statusCode == 200) {
        Map<String, dynamic> jsonData = resp.data;
        return [DiaryMonthModel.fromJson(jsonData)]; // 단일 객체를 리스트로 변환
      } else {
        print('Failed to load data with status code: ${resp.statusCode}');
        return Future.error('Error loading data');
      }
    } catch (e) {
      print('An exception occurred: $e');
      throw Exception('Failed to communicate with server');
    }
  }

  //
  // DefaultSliverContainer _emotionSliver() {
  //   return DefaultSliverContainer(
  //     height: 470,
  //     child: FutureBuilder<List<DiaryMonthModel>>(
  //         future: sendDiaryToBackend(UserManager().getUserId().toString(), DateFormat('yyyy-MM').format(DateTime.now())),
  //         builder: (_, AsyncSnapshot<List<DiaryMonthModel>> snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return _buildGraphSkeletonUI();
  //           } else if (snapshot.hasData) {
  //             return Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 RichText(
  //                   text: TextSpan(
  //                     text: '1개월 ',
  //                     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'KCC-Ganpan'),
  //                     children: <TextSpan>[
  //                       TextSpan(text: '감정 변화 그래프.', style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal)),
  //                     ],
  //                   ),
  //                 ),
  //                 BarChartSample7(
  //                   model: snapshot.data!,
  //                 ),
  //               ],
  //             );
  //           } else {
  //             return Center(
  //               child: Text('데이터가 없습니다'),
  //             );
  //           }
  //         }),
  //   );
  // }

  // 한 달 감정 피드백
  DefaultSliverContainer _feedbackSliver() {
    return DefaultSliverContainer(
      height: 100,
      child: ListView(
        children: <Widget>[
          FutureBuilder<List<DiaryMonthModel>>(
            future: _emotionFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '<한 달 간의 요약>',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Calendar()));
                            },
                            child: Text('캘린더로 가기'),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(12.0),
                      //   child: Text(snapshot.data![0].monthFeedback),
                      // ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('데이터를 불러오는 중 에러가 발생했습니다.'),
                );
              } else {
                return Center(
                  child: Text('데이터가 없습니다.'),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSkeletonUI() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildloginskeletonUI() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 20,
                      color: Colors.grey[200],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 100,
                      height: 20,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity, // 전체 너비 사용
                      height: 40, // 입력란 스켈레톤 높이
                      color: Colors.grey[200], // 스켈레톤 색상 지정
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 5,
            child: Icon(
              Icons.edit,
              color: Colors.grey[300], // 아이콘 스켈레톤 색상 지정
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryContainerUI() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    color: Colors.grey[300],
                  ),
                );
              },
            ),
          ),
          Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () {},
                child: Container(
                  color: Colors.grey[300],
                  child: Text('더보기'),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildGraphSkeletonUI() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 350,
        color: Colors.grey[300],
        child: Container(
          color: Colors.grey[300],
        ),
      ),
    );
  }
}