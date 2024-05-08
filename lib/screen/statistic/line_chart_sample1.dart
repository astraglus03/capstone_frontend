import 'package:capstone_frontend/screen/statistic/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChart extends StatelessWidget {
  const _LineChart({required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    minX: 0,
    maxX: 8, // 이거 감정 대화 횟수 자동으로 바꿔지게 해야 함
    maxY: 4,
    minY: 0,
  );

  LineChartData get sampleData2 => LineChartData( // 새로고침 아이콘 누르면 나오는 그래프
    lineTouchData: lineTouchData2,
    gridData: gridData,
    titlesData: titlesData2,
    borderData: borderData,
    lineBarsData: lineBarsData2,
    minX: 0,
    maxX: 7,
    maxY: 6,
    minY: 0,
  );

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
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarData1_2,
    lineChartBarData1_3,
    lineChartBarData1_4,
    lineChartBarData1_5,
    lineChartBarData1_6,
    lineChartBarData1_7,

  ];

  LineTouchData get lineTouchData2 => const LineTouchData(
    enabled: false,
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData2 => [
    lineChartBarData2_1,
    lineChartBarData2_2,
    lineChartBarData2_3,
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) { //y축
      case 1:
        text = '1m';
        break;
      case 2:
        text = '2m';
        break;
      case 3:
        text = '3m';
        break;
      case 4:
        text = '5m';
        break;
      case 5:
        text = '6m';
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

  // 처음 나오는 그래프
  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: Color(0xB866EAF6),
    barWidth: 4,
    //isStrokeCapRound: true,
    curveSmoothness: 0,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 1.5),
      FlSpot(5, 1.4),
      FlSpot(7, 3.4),
    ],
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: Color(0xB89EF168),
    barWidth: 4,
    //isStrokeCapRound: true,
    curveSmoothness: 0,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(
      show: false,
      color: AppColors.contentColorPink.withOpacity(0),
    ),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
    ],
  );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
    isCurved: true,
    color: Color(0xB8F3797A),
    barWidth: 4,
    //isStrokeCapRound: true,
    curveSmoothness: 0,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 2.8),
      FlSpot(3, 1.9),
      FlSpot(7, 3),
    ],
  );

  LineChartBarData get lineChartBarData1_4 => LineChartBarData(
    isCurved: true,
    color: Color(0xB8C1AEFA),
    barWidth: 4,
    //isStrokeCapRound: true,
    curveSmoothness: 0,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 1.3),
      FlSpot(3, 2.8),
      FlSpot(7, 3.1),
    ],
  );

  LineChartBarData get lineChartBarData1_5 => LineChartBarData(
    isCurved: true,
    color: Color(0xB8F8D315),
    barWidth: 4,
    //isStrokeCapRound: true,
    curveSmoothness: 0,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 0.7),
      FlSpot(3, 0.3),
      FlSpot(7, 2.3),
    ],
  );

  LineChartBarData get lineChartBarData1_6 => LineChartBarData(
    isCurved: true,
    color: Color(0xB8F5C1FF),
    barWidth: 4,
    //isStrokeCapRound: true,
    curveSmoothness: 0,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 0.0),
      FlSpot(3, 1.6),
      FlSpot(7, 1.2),
    ],
  );

  LineChartBarData get lineChartBarData1_7 => LineChartBarData(
    isCurved: true,
    color: Color(0xFF9ACAEF),
    barWidth: 4,
    //isStrokeCapRound: true,
    curveSmoothness: 0,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 0.3),
      FlSpot(3, 1.7),
      FlSpot(7, 0.8),
    ],
  );

  // 새로고침 눌렀을 때 나오는 그래프
  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
    isCurved: true,
    curveSmoothness: 0,
    color: AppColors.contentColorGreen.withOpacity(0.5),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 4),
      FlSpot(5, 1.8),
      FlSpot(7, 5),

    ],
  );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
    isCurved: true,
    color: AppColors.contentColorPink.withOpacity(0.5),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: AppColors.contentColorPink.withOpacity(0.2),
    ),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),

    ],
  );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
    isCurved: true,
    curveSmoothness: 0,
    color: AppColors.contentColorCyan.withOpacity(0.5),
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 3.8),
      FlSpot(3, 1.9),
      FlSpot(6, 5),
    ],
  );
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
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
              const SizedBox(
                height: 37,
              ),
              // const Text(
              //   'Monthly Sales',
              //   style: TextStyle(
              //     color: AppColors.primary,
              //     fontSize: 32,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 2,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: _LineChart(isShowingMainData: isShowingMainData),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
