import 'package:capstone_frontend/screen/statistic/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:capstone_frontend/screen/statistic/resources/indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PieChartCase extends StatefulWidget {
  final List emotionList;
  PieChartCase({super.key, required this.emotionList});

  @override
  _PieChart2State createState() => _PieChart2State();
}

class _PieChart2State extends State<PieChartCase> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    Map<String, int> emotionCounts = {
      '감정변화 O':widget.emotionList[0],
      '감정변화 X':widget.emotionList[1],
    };
    final totalEmotions = emotionCounts.values.reduce((value, element) => value + element);
    final List<PieChartSectionData> sections = _createChartSections(emotionCounts, totalEmotions);

    return AspectRatio(
      aspectRatio: 2.5,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 20,
                  sections: sections,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildIndicators(emotionCounts),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  // Map<String, int> _countEmotions(List emotions) {
  //   Map<String, int> counts = {};
  //   for (var emotion in emotions) {
  //     counts[emotion] = (counts[emotion] ?? 0) + 1;
  //   }
  //   return counts;
  // }

  List<PieChartSectionData> _createChartSections(Map<String, int> emotionCounts, int total) {
    List<PieChartSectionData> sections = [];
    int i = 0;
    emotionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))  // 높은 빈도순으로 정렬
      ..forEach((entry) {
        final isTouched = i == touchedIndex;
        sections.add(PieChartSectionData(
          color: AppColors.colors[i % AppColors.colors.length],
          value: (entry.value / total * 100).toDouble(),
          title: '${(entry.value / total * 100).toInt()}%',
          radius: isTouched ? 60.0 : 50.0,
          titleStyle: TextStyle(
            fontSize: isTouched ? 25.0 : 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
          ),
        ));
        i++;
      });
    return sections;
  }

  List<Widget> _buildIndicators(Map<String, int> emotionCounts) {
    List<Widget> indicators = [];
    emotionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..asMap().forEach((index, entry) {
        indicators.add(Indicator(
          color: AppColors.colors[index % AppColors.colors.length],
          text: entry.key,
          isSquare: true,
        ));
        indicators.add(const SizedBox(height: 4));
      });
    indicators.add(const SizedBox(height: 18));
    return indicators;
  }
}
