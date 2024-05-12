import 'package:capstone_frontend/screen/statistic/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChart extends StatelessWidget {
  final bool isShowingMainData;
  final String chatCount;
  final List<String> textEmo;
  final List<String> voiceEmo;

  const _LineChart({
    required this.isShowingMainData,
    required this.chatCount,
    required this.textEmo,
    required this.voiceEmo,
  });

  @override
  Widget build(BuildContext context) {
    // 문자열을 정수로 파싱한 후 double로 변환
    double maxX = (int.tryParse(chatCount) ?? 0).toDouble(); // int로 하면 안 됨
    return LineChart(
      isShowingMainData ? TextGraph(maxX) : VoiceGraph(maxX),
      duration: const Duration(milliseconds: 250),
    );
  }

  //새로운 그래프 로직
  LineChartData TextGraph(double maxX) {
    final emotionCountMap = <String, List<FlSpot>>{};
    Map<String, int> emotionAccumulatedCounts = {};

    // 감정 누적 카운트 초기화
    for (var emotion in textEmo.toSet()) {
      emotionAccumulatedCounts[emotion] = 0;
      emotionCountMap[emotion] = [FlSpot(0, 0)]; // 시작점을 (0, 0)으로 설정
    }

    //textEmo
    // 각 x 좌표에서 감정별 누적 횟수 계산
    for (var i = 0; i < textEmo.length; i++) {
      final emotion = textEmo[i];
      emotionAccumulatedCounts[emotion] = emotionAccumulatedCounts[emotion]! + 1;

      // 모든 감정에 대해 현재 누적 횟수 업데이트
      for (var emo in emotionAccumulatedCounts.keys) {
        emotionCountMap[emo]!.add(FlSpot(i.toDouble() + 1, emotionAccumulatedCounts[emo]!.toDouble()));
      }
    }

    final lineBarsData = emotionCountMap.entries.map((entry) {
      // 감정에 따른 색상 지정
      Color color;
      switch (entry.key) {
        case "중립":
          color = Colors.grey;  // 중립은 회색
          break;
        case "슬픔":
          color = Colors.blue;  // 슬픔은 파란색
          break;
        case "분노":
          color = Colors.red;
          break;
        case "행복":
          color = Colors.green;
          break;
        case "당황":
          color = Colors.yellow;
          break;
        case "상처":
          color = Colors.orange;
          break;
        case "불안":
          color = Colors.purple;
          break;

        default:
          color = Colors.black;  // 기본값은 검정색
          break;
      }

      return LineChartBarData(
        isCurved: false, // 부드럽게 연결 여부
        color: color,
        barWidth: 4,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: entry.value,
      );
    }).toList();

    return LineChartData(
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      ),
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: (value, meta) {
              final style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              );
              return Text(value.toInt().toString(), style: style);
            },
            showTitles: true,
            reservedSize: 32,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: (value, meta) {
              return Text('${value.toInt()}', style: TextStyle(fontWeight: FontWeight.bold));
            },
            showTitles: true,
            reservedSize: 40,
            interval: 1,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 4),
          left: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 4),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      ),
      minX: 0,
      maxX: maxX,
      minY: 0,
      maxY: 7,
      lineBarsData: lineBarsData,
    );
  }

  LineChartData VoiceGraph(double maxX) {
    final emotionCountMap = <String, List<FlSpot>>{};
    Map<String, int> emotionAccumulatedCounts = {};

    // 감정 누적 카운트 초기화
    for (var emotion in voiceEmo.toSet()) {
      emotionAccumulatedCounts[emotion] = 0;
      emotionCountMap[emotion] = [FlSpot(0, 0)]; // 시작점을 (0, 0)으로 설정
    }

    //voiceEmo
    // 각 x 좌표에서 감정별 누적 횟수 계산
    for (var i = 0; i < voiceEmo.length; i++) {
      final emotion = voiceEmo[i];
      emotionAccumulatedCounts[emotion] = emotionAccumulatedCounts[emotion]! + 1;

      // 모든 감정에 대해 현재 누적 횟수 업데이트
      for (var emo in emotionAccumulatedCounts.keys) {
        emotionCountMap[emo]!.add(FlSpot(i.toDouble() + 1, emotionAccumulatedCounts[emo]!.toDouble()));
      }
    }

    final lineBarsData = emotionCountMap.entries.map((entry) {
      // 감정에 따른 색상 지정
      Color color;
      switch (entry.key) {
        case "중립":
          color = Colors.grey;  // 중립은 회색
          break;
        case "슬픔":
          color = Colors.blue;  // 슬픔은 파란색
          break;
        case "분노":
          color = Colors.red;
          break;
        case "행복":
          color = Colors.green;
          break;
        case "당황":
          color = Colors.yellow;
          break;
        case "상처":
          color = Colors.orange;
          break;
        case "불안":
          color = Colors.purple;
          break;

        default:
          color = Colors.black;  // 기본값은 검정색
          break;
      }

      return LineChartBarData(
        isCurved: false, // 부드럽게 연결 여부
        color: color,
        barWidth: 4,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: entry.value,
      );
    }).toList();

    return LineChartData(
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      ),
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: (value, meta) {
              final style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              );
              return Text(value.toInt().toString(), style: style);
            },
            showTitles: true,
            reservedSize: 32,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: (value, meta) {
              return Text('${value.toInt()}', style: TextStyle(fontWeight: FontWeight.bold));
            },
            showTitles: true,
            reservedSize: 40,
            interval: 1,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 4),
          left: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 4),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      ),
      minX: 0,
      maxX: maxX,
      minY: 0,
      maxY: 7,
      lineBarsData: lineBarsData,
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),

    topTitles:AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );


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
      case 8:
        text = const Text('8', style: style);
        break;
      case 9:
        text = const Text('9', style: style);
        break;
      case 10:
        text = const Text('10', style: style);
        break;

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

  const LineChartSample1({super.key,
    required this.chatCount, required this.textEmo,required this.voiceEmo}); // Constructor 수정

  @override
  State<LineChartSample1> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 37),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(
                    isShowingMainData: isShowingMainData,
                    chatCount: widget.chatCount,
                    textEmo: widget.textEmo,
                    voiceEmo: widget.voiceEmo,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
        ],
      ),
    );
  }
}
