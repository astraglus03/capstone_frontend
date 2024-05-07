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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2024년 05월 02일'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: CustomScrollView(
          slivers: [
            _hashtagSliver(),
            _emotionSliver(),
            _rateSliver(),
            _pictureSliver(),
            _diarySliver(),
            _feedbackSliver()
          ],
        ),
      ),
    );
  }

  // 해시태그
  DefaultSliverContainer _hashtagSliver() {
    return const DefaultSliverContainer(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('#행복', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
          SizedBox(width: 20),
          Text('#당황', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
          SizedBox(width: 20),
          Text('#불안', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
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

  // 감정 비율 그래프
  DefaultSliverContainer _rateSliver() {
    return DefaultSliverContainer(
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('감정 비율 그래프'),
          PieChartSample2(),
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

  // 그림
  DefaultSliverContainer _pictureSliver() {
    return DefaultSliverContainer(
      height: 200,
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
      height: 400,
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
    return const DefaultSliverContainer(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('피드백'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ // 텍스트가 아닌 아이콘으로 대체 예정
              Text('피드백입니다아아아앙'),
            ],
          ),
        ],
      ),
    );
  }
}
