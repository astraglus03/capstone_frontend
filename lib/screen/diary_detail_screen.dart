import 'package:capstone_frontend/screen/statistic/bar_chart_sample7.dart';
import 'package:capstone_frontend/screen/statistic/line_chart_sample1.dart';
import 'package:capstone_frontend/screen/statistic/pie_chart_sample2.dart';
import 'package:flutter/material.dart';

import '../const/default_sliver_padding.dart';

class DiaryDetailScreen extends StatefulWidget {
  const DiaryDetailScreen({super.key});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreen();
}

class _DiaryDetailScreen extends State<DiaryDetailScreen> {
  bool _showEmotionSliver = false;  // 감정 변화 그래프 표시 상태를 저장하는 변수

  void _toggleEmotionSliver() {
    setState(() {
      _showEmotionSliver = !_showEmotionSliver;  // 토글
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
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: CustomScrollView(
          slivers: [
            _hashtagSliver(),
            _pictureSliver(),
            _diarySliver(),
            if (_showEmotionSliver) _emotionSliver(),  // 조건부 표시
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
          Text('#행복', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
          SizedBox(width: 20),
          Text('#당황', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
          SizedBox(width: 20),
          Text('#불안', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  // 스레드 내 감정변화 그래프
  DefaultSliverContainer _emotionSliver() {
    return DefaultSliverContainer(
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('감정 변화 그래프'),
          LineChartSample1(),
        ],
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
            children: [ // 텍스트가 아닌 아이콘으로 대체 예정
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
              Expanded( // 중간 공간을 채움
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                  children: [
                    TextButton(
                      onPressed: _toggleEmotionSliver,  // 토글 함수 연결
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
}