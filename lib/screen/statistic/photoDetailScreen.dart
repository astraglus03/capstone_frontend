import 'package:flutter/material.dart';
import 'package:capstone_frontend/screen/diary_detail_screen.dart';

class PhotoDetailScreen extends StatefulWidget {
  const PhotoDetailScreen({Key? key}) : super(key: key);

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  // 사진 목록을 위한 임시 데이터
  final List<Map<String, String>> images = [
    {'url': 'asset/img.webp', 'name': '2024/05/01', 'description': '#행복 #당황'},
    {'url': 'asset/kakao.png', 'name': '2024/05/02', 'description': '#슬픔 #불안'},
    {'url': 'asset/naver.png', 'name': '사진 이름 3', 'description': '사진 설명 3'},
    {'url': 'asset/img.webp', 'name': '사진 이름 1', 'description': '사진 설명 1'},
    {'url': 'asset/kakao.png', 'name': '사진 이름 2', 'description': '사진 설명 2'},
    {'url': 'asset/naver.png', 'name': '사진 이름 3', 'description': '사진 설명 3'},
    {'url': 'asset/img.webp', 'name': '사진 이름 1', 'description': '사진 설명 1'},
    {'url': 'asset/kakao.png', 'name': '사진 이름 2', 'description': '사진 설명 2'},
    {'url': 'asset/naver.png', 'name': '사진 이름 3', 'description': '사진 설명 3'},
    {'url': 'asset/img.webp', 'name': '사진 이름 1', 'description': '사진 설명 1'},
    {'url': 'asset/kakao.png', 'name': '사진 이름 2', 'description': '사진 설명 2'},
    {'url': 'asset/naver.png', 'name': '사진 이름 3', 'description': '사진 설명 3'},
    // 추가 이미지 데이터
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(135, 206, 235, 1),
        title: const Text(
          '앨범',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('나의 앨범', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // 스크롤뷰 내부의 그리드 스크롤 방지
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 한 줄에 2개 이미지
                      crossAxisSpacing: 10, // 가로 간격
                      mainAxisSpacing: 10, // 세로 간격
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DiaryDetailScreen()), // diary_detail_screen() 호출
                          );
                        },
                        child: GridTile(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(images[index]['url']!, fit: BoxFit.cover),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                child: Text(images[index]['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Text(images[index]['description']!, style: TextStyle(color: Colors.grey[600])),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
