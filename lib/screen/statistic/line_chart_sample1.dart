import 'package:capstone_frontend/screen/statistic/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';


enum GraphType {
  voice,
  abs,
  text,
}
class _LineChart extends StatelessWidget {
  final GraphType graphType;
  final String chatCount;
  final List<String> textEmo;
  final List<String> voiceEmo;
  final List<String> absEmo;

  const _LineChart({
    required this.graphType,
    required this.chatCount,
    required this.textEmo,
    required this.voiceEmo,
    required this.absEmo,
  });

  @override
  Widget build(BuildContext context) {
    // 문자열을 정수로 파싱한 후 double로 변환
    double maxX = (int.tryParse(chatCount) ?? 0).toDouble();

    switch (graphType) {
      case GraphType.voice:
        return LineChart(VoiceGraph(maxX));
      case GraphType.abs:
        return LineChart(AbsGraph(maxX));
      case GraphType.text:
        return LineChart(TextGraph(maxX));
      default:
        return LineChart(TextGraph(maxX));
    }
  }

  //새로운 그래프 로직
  LineChartData TextGraph(double maxX) {
    final emotionCountMap = <String, List<FlSpot>>{};
    Map<String, int> emotionAccumulatedCounts = {};

    // Initialize emotion count
    for (var emotion in textEmo.toSet()) {
      emotionAccumulatedCounts[emotion] = 0;
      emotionCountMap[emotion] = [FlSpot(0, 0)];
    }

    // Accumulate emotions
    for (var i = 0; i < textEmo.length; i++) {
      final emotion = textEmo[i];
      emotionAccumulatedCounts[emotion] = emotionAccumulatedCounts[emotion]! + 1;

      // Update spots for each emotion
      for (var emo in emotionAccumulatedCounts.keys) {
        emotionCountMap[emo]!.add(FlSpot(i.toDouble() + 1, emotionAccumulatedCounts[emo]!.toDouble()));
      }
    }

    final lineBarsData = emotionCountMap.entries.map((entry) {
      Color color = entry.key == "중립" ? Colors.grey :
      entry.key == "슬픔" ? Colors.blue :
      entry.key == "분노" ? Colors.red :
      entry.key == "행복" ? Colors.green :
      entry.key == "당황" ? Colors.yellow :
      entry.key == "상처" ? Colors.orange :
      entry.key == "불안" ? Colors.purple : Colors.black;  // 색상 매핑

      return LineChartBarData(
        isCurved: false,
        color: color,
        barWidth: 4,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: entry.value,
      );
    }).toList();

    return LineChartData(
      lineTouchData: _getLineTouchData(),  // 클릭->감정,수치 함께 보여줌
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: bottomTitles),
        leftTitles: AxisTitles(sideTitles: leftTitles()),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 상단 제목을 표시하지 않음
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 우측 제목을 표시하지 않음
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(bottom: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 4), // 아래쪽 테두리 색상 및 두께 지정
          left: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 4),    // 왼쪽 테두리 색상 및 두께 지정
        ),
      ),

      minX: 0,
      maxX: maxX+1,
      minY: 0,
      maxY: emotionAccumulatedCounts.values.isNotEmpty ? (emotionAccumulatedCounts.values.reduce(max) + 2).toDouble() : 7,
      lineBarsData: lineBarsData,
    );
  }

  LineChartData VoiceGraph(double maxX) {
    final emotionCountMap = <String, List<FlSpot>>{};
    Map<String, int> emotionAccumulatedCounts = {};

    // Initialize emotion count
    for (var emotion in voiceEmo.toSet()) {
      emotionAccumulatedCounts[emotion] = 0;
      emotionCountMap[emotion] = [FlSpot(0, 0)];
    }

    // Accumulate emotions
    for (var i = 0; i < voiceEmo.length; i++) {
      final emotion = voiceEmo[i];
      emotionAccumulatedCounts[emotion] = emotionAccumulatedCounts[emotion]! + 1;

      // Update spots for each emotion
      for (var emo in emotionAccumulatedCounts.keys) {
        emotionCountMap[emo]!.add(FlSpot(i.toDouble() + 1, emotionAccumulatedCounts[emo]!.toDouble()));
      }
    }

    final lineBarsData = emotionCountMap.entries.map((entry) {
      Color color = entry.key == "중립" ? Colors.grey :
      entry.key == "슬픔" ? Colors.blue :
      entry.key == "분노" ? Colors.red :
      entry.key == "행복" ? Colors.green :
      entry.key == "당황" ? Colors.yellow :
      entry.key == "상처" ? Colors.orange :
      entry.key == "불안" ? Colors.purple : Colors.black;  // 색상 매핑

      return LineChartBarData(
        isCurved: false,
        color: color,
        barWidth: 4,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: entry.value,
      );
    }).toList();

    return LineChartData(
      lineTouchData: _getLineTouchData(),  // 클릭->감정,수치 함께 보여줌
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: bottomTitles),
        leftTitles: AxisTitles(sideTitles: leftTitles()),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 상단 제목을 표시하지 않음
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 우측 제목을 표시하지 않음
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(bottom: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 4), // 아래쪽 테두리 색상 및 두께 지정
          left: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 4),    // 왼쪽 테두리 색상 및 두께 지정
        ),
      ),

      minX: 0,
      maxX: maxX+1,
      minY: 0,
      maxY: emotionAccumulatedCounts.values.isNotEmpty ? (emotionAccumulatedCounts.values.reduce(max) + 2).toDouble() : 7,
      lineBarsData: lineBarsData,
    );
  }

  LineChartData AbsGraph(double maxX) {
    final emotionCountMap = <String, List<FlSpot>>{};
    Map<String, int> emotionAccumulatedCounts = {};

    // Initialize emotion count
    for (var emotion in absEmo.toSet()) {
      emotionAccumulatedCounts[emotion] = 0;
      emotionCountMap[emotion] = [FlSpot(0, 0)];
    }

    // Accumulate emotions
    for (var i = 0; i < absEmo.length; i++) {
      final emotion = absEmo[i];
      emotionAccumulatedCounts[emotion] = emotionAccumulatedCounts[emotion]! + 1;

      // Update spots for each emotion
      for (var emo in emotionAccumulatedCounts.keys) {
        emotionCountMap[emo]!.add(FlSpot(i.toDouble() + 1, emotionAccumulatedCounts[emo]!.toDouble()));
      }
    }

    final lineBarsData = emotionCountMap.entries.map((entry) {
      Color color = entry.key == "중립" ? Colors.grey :
      entry.key == "슬픔" ? Colors.blue :
      entry.key == "분노" ? Colors.red :
      entry.key == "행복" ? Colors.green :
      entry.key == "당황" ? Colors.yellow :
      entry.key == "상처" ? Colors.orange :
      entry.key == "불안" ? Colors.purple : Colors.black;  // 색상 매핑

      return LineChartBarData(
        isCurved: false,
        color: color,
        barWidth: 4,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: entry.value,
      );
    }).toList();

    return LineChartData(
      lineTouchData: _getLineTouchData(),  // 클릭->감정,수치 함께 보여줌
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: bottomTitles),
        leftTitles: AxisTitles(sideTitles: leftTitles()),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 상단 제목을 표시하지 않음
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 우측 제목을 표시하지 않음
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(bottom: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 4), // 아래쪽 테두리 색상 및 두께 지정
          left: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 4),    // 왼쪽 테두리 색상 및 두께 지정
        ),
      ),

      minX: 0,
      maxX: maxX+1,
      minY: 0,
      maxY: emotionAccumulatedCounts.values.isNotEmpty ? (emotionAccumulatedCounts.values.reduce(max) + 2).toDouble() : 7,
      lineBarsData: lineBarsData,
    );
  }

  // 그래프 터치했을 때, 감정 수치 보여주기
  LineTouchData _getLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => Colors.black54.withOpacity(0.8),
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((LineBarSpot spot) {
            final String emotion = spot.bar.color == Colors.grey
                ? "중립"
                : spot.bar.color == Colors.blue
                ? "슬픔"
                : spot.bar.color == Colors.red
                ? "분노"
                : spot.bar.color == Colors.green
                ? "행복"
                : spot.bar.color == Colors.yellow
                ? "당황"
                : spot.bar.color == Colors.orange
                ? "상처"
                : spot.bar.color == Colors.purple
                ? "불안"
                : "기타";  // 기본값 추가
            return LineTooltipItem(
              '$emotion: ${spot.y}',  // 소수점 둘째자리까지 표시
              TextStyle(color: spot.bar.color, fontWeight: FontWeight.bold),
            );
          }).toList();
        },
      ),
      handleBuiltInTouches: true,
    );
  }


  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) { //y축
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;
      case 5:
        text = '5';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 1,
    reservedSize: 40,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) { //x축
      case 1:
        text = const Text('1', style: style);
        break;
      case 2:
        text = const Text('2', style: style);
        break;
      case 3:
        text = const Text('3', style: style);
        break;
      case 4:
        text = const Text('4', style: style);
        break;
      case 5:
        text = const Text('5', style: style);
        break;
      case 6:
        text = const Text('6', style: style);
        break;
      case 7:
        text = const Text('7', style: style);
        break;
      // case 8:
      //   text = const Text('8', style: style);
      //   break;
      // case 9:
      //   text = const Text('9', style: style);
      //   break;
      // case 10:
      //   text = const Text('10', style: style);
      //   break;

      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  // 대화 횟수마다 세로선 그려주기
  FlGridData get gridData => FlGridData(
    show: true,
    drawVerticalLine: true,
    verticalInterval: 1, // 각 x 값마다 세로선을 그립니다.
    getDrawingVerticalLine: (value) {
      return FlLine(
        color: Colors.blueGrey.withOpacity(0.1),  // 선의 색상 설정
        strokeWidth: 0.5, // 선의 두께 설정
      );
    },
    getDrawingHorizontalLine: (value) {
      return FlLine(
        color: Colors.blueGrey.withOpacity(0.1),  // 가로선 색상 설정
        strokeWidth: 0.5, // 가로선 두께 설정
      );
    },
  );


  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom:
      BorderSide(color: AppColors.primary.withOpacity(0.2), width: 4),
      left: const BorderSide(color: Colors.transparent),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    ),
  );

}

class LineChartSample1 extends StatefulWidget {
  final String chatCount;
  final List<String> textEmo;
  final List<String> voiceEmo;
  final List<String> absEmo;

  const LineChartSample1({super.key,
    required this.chatCount, required this.textEmo,required this.voiceEmo,required this.absEmo}); // Constructor 수정

  @override
  State<LineChartSample1> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;
  late GraphType currentGraphType;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    currentGraphType = GraphType.abs;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 48, // 원 크기 지정
                height: 48, // 원 크기 지정
                decoration: BoxDecoration(
                  color: currentGraphType == GraphType.abs ? Color(0xFFC9F5FF) : Colors.transparent,
                  shape: BoxShape.circle, // 원형 배경
                ),
                child: IconButton(
                  icon: Icon(Icons.auto_graph_rounded, size: 24),
                  onPressed: () {
                    setState(() {
                      currentGraphType = GraphType.abs;
                    });
                  },
                  tooltip: '텍스트 감정',
                ),
              ),
              Container(
                width: 48, // 원 크기 지정
                height: 48, // 원 크기 지정
                decoration: BoxDecoration(
                  color: currentGraphType == GraphType.text ? Color(0xFFC9F5FF) : Colors.transparent,
                  shape: BoxShape.circle, // 원형 배경
                ),
                child: IconButton(
                  icon: Icon(Icons.text_fields_rounded, size: 24),
                  onPressed: () {
                    setState(() {
                      currentGraphType = GraphType.text;
                    });
                  },
                  tooltip: '음성 감정',
                ),
              ),
              Container(
                width: 48, // 원 크기 지정
                height: 48, // 원 크기 지정
                decoration: BoxDecoration(
                  color: currentGraphType == GraphType.voice ? Color(0xFFC9F5FF) : Colors.transparent,
                  shape: BoxShape.circle, // 원형 배경
                ),
                child: IconButton(
                  icon: Icon(Icons.keyboard_voice_rounded, size: 24),
                  onPressed: () {
                    setState(() {
                      currentGraphType = GraphType.voice;
                    });
                  },
                  tooltip: '통합 감정',
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 6),
              child: _LineChart(
                graphType: currentGraphType,
                chatCount: widget.chatCount,
                textEmo: widget.textEmo,
                voiceEmo: widget.voiceEmo,
                absEmo: widget.absEmo,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
