import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartEachDay extends StatefulWidget {
  final List<String> emotionList;

  const PieChartEachDay({
    super.key,
    required this.emotionList,
  });

  @override
  State<PieChartEachDay> createState() => _PieChartEachDayState();
}

class _PieChartEachDayState extends State<PieChartEachDay> {
  int touchedIndex = -1;

  final Map<String, Color> emotionColors = {
    '분노': Colors.red,
    '걱정': Colors.purple,
    '당황': Colors.orange,
    '행복': Colors.green,
    '상처': Colors.yellow,
    '중립': Colors.grey,
    '슬픔': Colors.blue,
  };

  @override
  Widget build(BuildContext context) {
    final emotionCounts = _countEmotions();
    final totalEmotions = widget.emotionList.length;

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
                  sections: _createChartSections(emotionCounts, totalEmotions),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildIndicators(emotionCounts),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Map<String, int> _countEmotions() {
    Map<String, int> counts = {};
    for (var emotion in widget.emotionList) {
      counts[emotion] = (counts[emotion] ?? 0) + 1;
    }
    return counts;
  }

  List<PieChartSectionData> _createChartSections(Map<String, int> emotionCounts, int total) {
    List<PieChartSectionData> sections = [];
    int i = 0;

    emotionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..forEach((entry) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 50.0;
        final color = emotionColors[entry.key] ?? Colors.grey;

        sections.add(
          PieChartSectionData(
            color: color,
            value: (entry.value / total * 100),
            title: '${(entry.value / total * 100).toInt()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
            ),
          ),
        );
        i++;
      });

    return sections;
  }

  List<Widget> _buildIndicators(Map<String, int> emotionCounts) {
    List<Widget> indicators = [];
    emotionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..forEach((entry) {
        indicators.add(
          Indicator(
            color: emotionColors[entry.key] ?? Colors.grey,
            text: entry.key,
            isSquare: true,
          ),
        );
        indicators.add(const SizedBox(height: 4));
      });

    return indicators;
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
