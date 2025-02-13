import 'package:capstone_frontend/common/component/default_sliver_padding2.dart';
import 'package:capstone_frontend/home/enum/emotion.dart';
import 'package:capstone_frontend/home/models/diary_detail_model.dart';
import 'package:capstone_frontend/home/view_models/diary_detail_provider.dart';
import 'package:capstone_frontend/home/view/widget/emotion_change_chart.dart';
import 'package:capstone_frontend/statistic/view/line_chart_sample1.dart';
import 'package:capstone_frontend/home/view/widget/pie_chart_eachday.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DiaryDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'diaryDetail';
  final String id;

  const DiaryDetailScreen({super.key, required this.id});

  @override
  ConsumerState<DiaryDetailScreen> createState() => _DiaryDetailScreen();
}

class _DiaryDetailScreen extends ConsumerState<DiaryDetailScreen> {
  // bool _showEmotionSliver = false;
  //
  // void _toggleEmotionSliver() {
  //   setState(() {
  //     _showEmotionSliver = !_showEmotionSliver;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(diaryDetailProvider(widget.id));

    return state.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      data: (diary) {
        if (diary == null) {
          return const Scaffold(
            body: Center(child: Text('일기를 찾을 수 없습니다.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(DateFormat('yyyy년 MM월 dd일').format(diary.date!)),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomScrollView(
              slivers: [
                _pictureSliver(diary),
                _diarySliver(diary),
                // if (_showEmotionSliver) _emotionSliver(diary),
                _emotionChangeSliver(diary),
                _pieChartSliver(diary),
                _feedbackSliver(diary),
              ],
            ),
          ),
        );
      },
    );
  }

  DefaultSliverContainer2 _emotionSliver(DiaryDetailModel diary) {
    return DefaultSliverContainer2(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            '<감정 누적 그래프>',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          // if (diary.textEmotion != null && diary.speechEmotion != null && diary.absEmotion != null)
          //   LineChartSample1(
          //     chatCount: diary.charCount ?? '0',
          //     textEmo: diary.textEmotion!,
          //     voiceEmo: diary.speechEmotion!,
          //     absEmo: diary.absEmotion!,
          //   ),
        ],
      ),
    );
  }

  DefaultSliverContainer2 _pictureSliver(DiaryDetailModel diary) {
    return DefaultSliverContainer2(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (diary.absEmotion != null)
            Text(
              diary.absEmotion!.toSet().map((e) => '#$e').join(' '),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 10),
          if (diary.image != null)
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(diary.image!, fit: BoxFit.cover),
              ),
            ),
        ],
      ),
    );
  }

  DefaultSliverContainer2 _diarySliver(DiaryDetailModel diary) {
    return DefaultSliverContainer2(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            '<일기 내용>',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            diary.content ?? '내용 없음',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  DefaultSliverContainer2 _emotionChangeSliver(DiaryDetailModel diary) {
    return DefaultSliverContainer2(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            '<감정 변화 그래프>',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '감정 변화',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...diary.absEmotion!.map((emotion) => Row(
                    children: [
                      Container(
                        width: 35,
                        height: 75,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Emotion.fromString(emotion).imagePath),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                    ],
                  )).toList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '최종 감정 변화',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          EmotionChangeChart(
            absEmotions: diary.absEmotion,
            overallFeedback: diary.overallFeedback,
            isSimpleMode: true,
          ),
          const SizedBox(height: 10),
          Text(
            '대화 속 감정 변화',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          EmotionChangeChart(
            emotionChanges: diary.emotionChanges!,
          ),
        ],
      ),
    );
  }

  DefaultSliverContainer2 _pieChartSliver(DiaryDetailModel diary) {
    return DefaultSliverContainer2(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '<일기 감정 비율>',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Expanded(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       TextButton(
              //         onPressed: _toggleEmotionSliver,
              //         child: const Text('감정 변화 그래프 보기'),
              //       ),
              //       const Icon(Icons.show_chart),
              //     ],
              //   ),
              // ),
            ],
          ),
          if (diary.absEmotion != null)
            SizedBox(
              height: 200,
              child: PieChartEachDay(emotionList: diary.absEmotion!),
            ),
        ],
      ),
    );
  }

  DefaultSliverContainer2 _feedbackSliver(DiaryDetailModel diary) {
    return DefaultSliverContainer2(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '<피드백>',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(diary.feedback!),
        ],
      ),
    );
  }
}
