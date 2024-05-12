import 'dart:convert';
import 'dart:typed_data';
import 'package:capstone_frontend/const/api_utils.dart';
import 'package:capstone_frontend/const/currentuser_model.dart';
import 'package:capstone_frontend/const/default_sliver_padding.dart';
import 'package:capstone_frontend/login/kakao_login.dart';
import 'package:capstone_frontend/login/main_view_model.dart';
import 'package:capstone_frontend/screen/statistic/bar_chart_sample7.dart';
import 'package:capstone_frontend/screen/statistic/model/diary_model.dart';
import 'package:flutter/material.dart';
import 'package:capstone_frontend/screen/statistic/photoDetailScreen.dart';
import '../diary_detail_screen.dart';
import 'package:http/http.dart' as http;

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  final TextEditingController memoController = TextEditingController();
  final FocusNode memoFocusNode = FocusNode();
  bool _isFocused = false; // 메모란에 포커스 여부
  final viewmodel = MainViewModel(KakaoLogin());
  String? userId = UserManager().getUserId();
  final String limit = '2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: CustomScrollView(
          slivers: [
            _diaryInfoSliver(),
            _photoSliver(context),
            _emotionSliver(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    memoFocusNode.addListener(() {
      setState(() {
        _isFocused = memoFocusNode.hasFocus; // Update the focus status
      });
    });
  }

  @override
  void dispose() {
    memoController.dispose();
    memoFocusNode.dispose();
    super.dispose();
  }

  // 메모 수정 후 저장
  void _saveText() {
    print('Memo Saved: ${memoController.text}');
    memoFocusNode.unfocus(); // 포커스 해제
  }

  Future<CurrentUser?> checkCurrentUser(String userId) async {
    try {
      final resp = await http.get(Uri.parse('$ip/userinfo/userinfo/$userId'));
      if (resp.statusCode == 200) {
        var data = jsonDecode(resp.body);
        return CurrentUser.fromJson(data);
        // print("사용자 ID: ${data['userId']}");
        // print("닉네임: ${data['nickname']}");
        // print("프로필 이미지 URL: ${data['profileImage']}");
      } else {
        throw Exception('서버에서 정보를 가져오는 데 실패했습니다.');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  DefaultSliverContainer _diaryInfoSliver() {
    return DefaultSliverContainer(
      height: 150,
      child: FutureBuilder<CurrentUser?>(
        future: checkCurrentUser(userId!),
        builder: (_, AsyncSnapshot<CurrentUser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는 중 에러가 발생했습니다.'));
          } else if (snapshot.hasData) {
            return Stack(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(snapshot.data!.imageUrl),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                snapshot.data!.nickname,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () async {
                                  await viewmodel.logout();
                                  setState(() {});
                                },
                                child: Text('로그아웃'),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(30, 10),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: memoController,
                            focusNode: memoFocusNode,
                            decoration: InputDecoration(
                              labelText: '메모',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              isDense: true,
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                          if (_isFocused)
                            ElevatedButton(
                              onPressed: _saveText,
                              child: Text('저장하기'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 5,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      memoFocusNode.requestFocus();
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text("데이터가 없습니다")); // 데이터 없음 표시
          }
        },
      ),
    );
  }

  Future<List<DiaryModel>> getPhoto(String userId, String date, String month, String limit) async {
    final resp = await http.post(Uri.parse('$ip/Search_Diary_api/searchdiary'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'date': date,
          'month': month,
          'limit': limit,
        }));
    if (resp.statusCode == 200) {
      // print(resp.body);
      // print('가져오기 성공');
      // print('가져오기${jsonData.map((item) => PhotoModel.fromJson(item)).toList()}');
      List<dynamic> jsonData = jsonDecode(resp.body);
      return jsonData.map((item) => DiaryModel.fromJson(item)).toList();
    } else {
      print('Failed to load photo with status code: ${resp.statusCode}');
      print('Error body: ${resp.body}');
      throw Exception(
          'Failed to load photo with status code: ${resp.statusCode}');
    }
  }

  DefaultSliverContainer _photoSliver(BuildContext context) {
    return DefaultSliverContainer(
      height: 200,
      child: FutureBuilder<List<DiaryModel>>(
        future: getPhoto(userId!, 'None', 'None', limit),
        builder: (_, AsyncSnapshot<List<DiaryModel>> snapshot) {
          if (snapshot.hasError) {
            print('여기부분${snapshot.error}');
            return Center(child: Text('데이터를 불러오는 중 에러가 발생했습니다.'));
          } else if (snapshot.hasData) {
            return Row(
              children: [
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DiaryDetailScreen(
                                    photoDetail: snapshot.data![index],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.memory(
                                snapshot.data![index].image ?? Uint8List(0),
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoDetailScreen(),
                        ),
                      );
                    },
                    child: Text('더보기'),
                  )
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            ); // 데이터 없음 표시
          }
        },
      ),
    );
  }

  DefaultSliverContainer _emotionSliver() {
    return DefaultSliverContainer(
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('1개월 감정 변화 그래프'),
          BarChartSample7(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 텍스트가 아닌 아이콘으로 대체 예정
              Text('놀람'),
              Text('공포'),
              Text('분노'),
              Text('중립'),
              Text('행복'),
              Text('혐오'),
            ],
          ),
        ],
      ),
    );
  }
}
