import 'package:capstone_frontend/screen/statistic/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:capstone_frontend/screen/statistic/resources/indicator.dart';
import 'package:flutter/material.dart';

class PieChartSample2 extends StatefulWidget {
  final List<String> emotionList;

  PieChartSample2({super.key, required this.emotionList});

  @override
  _PieChart2State createState() => _PieChart2State();
}

class _PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final emotionCounts = _countEmotions(widget.emotionList);
    final totalEmotions = widget.emotionList.length;
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildIndicators(emotionCounts),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Map<String, int> _countEmotions(List<String> emotions) {
    Map<String, int> counts = {};
    for (var emotion in emotions) {
      counts[emotion] = (counts[emotion] ?? 0) + 1;
    }
    return counts;
  }

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
