import 'dart:convert';

import 'package:capstone_frontend/screen/statistic/bar_chart_sample7.dart';
import 'package:capstone_frontend/screen/statistic/line_chart_sample1.dart';
import 'package:capstone_frontend/screen/statistic/pie_chart_sample2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../const/default_sliver_padding.dart';
import 'package:capstone_frontend/const/api_utils.dart';

class DiaryDetailScreen extends StatefulWidget {
  const DiaryDetailScreen({super.key});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreen();
}

class _DiaryDetailScreen extends State<DiaryDetailScreen> {

  final userId = UserManager().getUserId();

  bool _showEmotionSliver = false; // 감정 변화 그래프 표시 상태를 저장하는 변수

  List<DiaryItem> diaryItems = []; // 다이어리 항목을 저장하는 리스트 선언

  void _toggleEmotionSliver() {
    setState(() {
      _showEmotionSliver = !_showEmotionSliver; // 토글
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2024년 05월 02일'),
        centerTitle: true,
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: CustomScrollView(
          slivers: [
            _hashtagSliver(),
            _pictureSliver(),
            _diarySliver(),
            if (_showEmotionSliver) _emotionSliver(), // 조건부 표시
            _feedbackSliver(),
            //_rateSliver(),
          ],
        ),
      ),
    );
  }

  // 해시태그
  DefaultSliverContainer _hashtagSliver() {
    return const DefaultSliverContainer(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#행복',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 20),
          Text(
            '#당황',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 20),
          Text(
            '#불안',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  // 스레드 내 감정변화 그래프
  DefaultSliverContainer _emotionSliver() {
    return DefaultSliverContainer(
      height: 350,
      child: FutureBuilder<List<DiaryItem>>(
        future: sendDiaryToBackend(userId!,  'None', 'None', 'None'),
        builder: (_, AsyncSnapshot<List<DiaryItem>> snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('데이터를 불러오는 중 에러가 발생했습니다. 에러: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var chatCount = snapshot.data!.first.chatCount;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('감정 변화 그래프'),
                LineChartSample1(chatCount: chatCount.toString(),),
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

  // 감정 비율 그래프
  DefaultSliverContainer _rateSliver() {
    return DefaultSliverContainer(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('감정 비율 그래프'),
          PieChartSample2(),
        ],
      ),
    );
  }

  // 그림
  DefaultSliverContainer _pictureSliver() {
    return DefaultSliverContainer(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('asset/img.webp', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  // 일기
  DefaultSliverContainer _diarySliver() {
    return const DefaultSliverContainer(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('일기 텍스트'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 텍스트가 아닌 아이콘으로 대체 예정
              Text('일기입니다아아아앙'),
            ],
          ),
        ],
      ),
    );
  }

  // 일기 피드백
  DefaultSliverContainer _feedbackSliver() {
    return DefaultSliverContainer(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝에 위젯 배치
            children: [
              Text('피드백'), // 왼쪽에 배치
              Expanded(
                // 중간 공간을 채움
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                  children: [
                    TextButton(
                      onPressed: _toggleEmotionSliver, // 토글 함수 연결
                      child: const Text('감정 변화 그래프 보기'),
                    ),
                    Icon(Icons.show_chart), // 그래프 아이콘
                  ],
                ),
              ),
            ],
          ),
          PieChartSample2(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('피드백입니다아아아앙 피드백입니다아아아앙 '),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<DiaryItem>> sendDiaryToBackend(
      String userId, String date, String month, String limit) async {
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

    print('Status Code: ${resp.statusCode}');
    print('Response Body: ${resp.body}');

    // 상태 코드 검사 추가
    if (resp.statusCode == 200) {
      // print(resp.body);
      // print('가져오기 성공');
      // print('가져오기${jsonData.map((item) => PhotoModel.fromJson(item)).toList()}');
      List<dynamic> jsonData = jsonDecode(resp.body);
      print(jsonData.length);
      return jsonData.map((item) => DiaryItem.fromJson(item)).toList();
    } else {
      print('Failed to load photo with status code: ${resp.statusCode}');
      print('Error body: ${resp.body}');
      throw Exception(
          'Failed to load photo with status code: ${resp.statusCode}');
    }
  }
}

// API 모델 역할
class DiaryItem {
  final String userId;
  final String date;
  final String content;
  final List textEmotion;
  final List speechEmotion;
  final int chatCount;

  DiaryItem({
    required this.userId,
    required this.date,
    required this.content,
    required this.textEmotion,
    required this.speechEmotion,
    required this.chatCount,
  });

  factory DiaryItem.fromJson(Map<String, dynamic> json) {
    return DiaryItem(
      userId: json['userId'],
      date: json['date'],
      content: json['content'],
      textEmotion: json['textEmotion'] is List ? json['textEmotion'] : [],
      speechEmotion: json['speechEmotion'] ?? '',
      chatCount: json['chatCount'] is int ? json['chatCount'] : 0,
    );
  }
}
