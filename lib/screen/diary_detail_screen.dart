import 'package:capstone_frontend/screen/statistic/line_chart_sample1.dart';
import 'package:capstone_frontend/screen/statistic/model/diary_model.dart';
import 'package:capstone_frontend/screen/statistic/pie_chart_sample2.dart';
import 'package:flutter/material.dart';
import'package:intl/intl.dart';
import 'package:capstone_frontend/const/default_sliver_padding.dart';
import 'package:capstone_frontend/const/api_utils.dart';

class DiaryDetailScreen extends StatefulWidget {
  final DiaryModel photoDetail;
  const DiaryDetailScreen({super.key, required this.photoDetail});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreen();
}

class _DiaryDetailScreen extends State<DiaryDetailScreen> {

  final userId = UserManager().getUserId();

  bool _showEmotionSliver = false; // 감정 변화 그래프 표시 상태를 저장하는 변수

  void _toggleEmotionSliver() {
    setState(() {
      _showEmotionSliver = !_showEmotionSliver; // 토글
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('yyyy년 MM월 dd일').format(widget.photoDetail.date!)),
        centerTitle: true,
      ),
      body: Padding(
        padding:
        const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: CustomScrollView(
          slivers: [
            _pictureSliver(),
            _diarySliver(),
            if (_showEmotionSliver) _emotionSliver(),
            _feedbackSliver(),
          ],
        ),
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
                SizedBox(height: 10,),
                Text('<감정 변화 그래프>', style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),
                LineChartSample1(
                  chatCount: widget.photoDetail.chatCount.toString(),
                  textEmo: widget.photoDetail.textEmotion!.cast<String>(),
                  voiceEmo: widget.photoDetail.speechEmotion!.cast<String>(),
                  absEmo: widget.photoDetail.absEmotion!.cast<String>(),
                ),
              ],
            ),
    );
  }

  // 그림
  DefaultSliverContainer _pictureSliver() {
    return DefaultSliverContainer(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10,),
          Text(widget.photoDetail.textEmotion!.toSet().map((e) => '#$e').join(' '), textAlign: TextAlign.start, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),),
          SizedBox(height: 10,),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(widget.photoDetail.image!,fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  // 일기
  DefaultSliverContainer _diarySliver() {
    return DefaultSliverContainer(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Text('<일기 내용>', style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),),
          SizedBox(height: 20,),
          Text(widget.photoDetail.content!,maxLines: 6, overflow: TextOverflow.ellipsis, style: TextStyle(
            fontSize: 14,
          ),),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('<일기 감정 비율>', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _toggleEmotionSliver,
                      child: const Text('감정 변화 그래프 보기'),
                    ),
                    Icon(Icons.show_chart),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: PieChartSample2(
              emotionList: widget.photoDetail.absEmotion!,
            ),
          ),
        ],
      ),
    );
  }
}