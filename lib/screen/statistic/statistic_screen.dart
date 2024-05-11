import 'package:capstone_frontend/const/api_utils.dart';
import 'package:capstone_frontend/const/currentuser_model.dart';
import 'package:capstone_frontend/const/default_sliver_padding.dart';
import 'package:capstone_frontend/login/kakao_login.dart';
import 'package:capstone_frontend/login/main_view_model.dart';
import 'package:capstone_frontend/screen/statistic/bar_chart_sample7.dart';
import 'package:flutter/material.dart';
import 'package:capstone_frontend/screen/statistic/photoDetailScreen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../diary_detail_screen.dart';

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
  CurrentUser? user;
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
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: CustomScrollView(
          slivers: [
            _diaryInfoSliver(),
            _photoVideoSliver(context),
            _emotionSliver(),
            //_diaryCountSliver(),
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
    memoFocusNode.unfocus();  // 포커스 해제
  }

  DefaultSliverContainer _diaryInfoSliver() {
    return DefaultSliverContainer(
      height: 150,
      child: FutureBuilder<CurrentUser?>(
        future: checkCurrentUser(userId!),
        builder: (BuildContext context, AsyncSnapshot<CurrentUser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는 중 에러가 발생했습니다.'));
          } else if (snapshot.hasData) {
            user = snapshot.data; // 사용자 데이터 업데이트
            return Stack(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: user?.imageUrl != null
                            ? NetworkImage(user!.imageUrl) as ImageProvider<Object>
                            : const AssetImage('asset/img.webp') as ImageProvider<Object>,
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
                                user?.nickname ?? '닉네임',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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

  DefaultSliverContainer _diaryCountSliver() {
    return DefaultSliverContainer(
      height: 100,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '0',
                      style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      '모든 일기',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 1,
              height: 40,
              child: Container(
                color: Colors.grey[400],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '0',
                      style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Text(
                      '즐겨보는 일기',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DefaultSliverContainer _photoVideoSliver(BuildContext context) {
    return DefaultSliverContainer(
      height: 200,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '모든 일기 모아보기',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailScreen(), // 더보기 버튼 눌렀을 때
                      ),
                    );
                  },
                  child: const Text('더보기 >'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DiaryDetailScreen()), // 첫 번째 이미지 클릭 시
                    );
                  },
                  child: Container(
                    height: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('asset/img.webp', fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DiaryDetailScreen()), // 두 번째 이미지 클릭 시
                    );
                  },
                  child: Container(
                    height: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset('asset/kakao.png', fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
            children: [ // 텍스트가 아닌 아이콘으로 대체 예정
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


