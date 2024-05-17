import 'dart:convert';
import 'dart:math' as math;
import 'package:capstone_frontend/screen/statistic/model/month_emotion_resp_model.dart';
import 'package:capstone_frontend/screen/statistic/model/month_feedback_model.dart';
import 'package:capstone_frontend/screen/statistic/resources/app_resources.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../const/api_utils.dart';
import 'package:http/http.dart' as http;

enum GraphType {
  voice,
  abs,
  text,
}

class BarChartSample7 extends StatefulWidget {
  final List<DiaryMonthModel> model;
  final dio = Dio();

  BarChartSample7({Key? key, required this.model}) : super(key: key);

  final shadowColor = const Color(0xFFCCCCCC);
  final dataList = [
    const _BarData(Colors.grey, 18, "중립"), //중립
    const _BarData(Colors.blue, 17, "슬픔"), //슬픔
    const _BarData(Colors.red, 10, "분노"), //분노
    const _BarData(Colors.green, 2.5, "행복"), //행복
    const _BarData(Colors.purple, 2, '불안'), //불안
    const _BarData(Colors.yellow, 2, "당황"), //당황
    const _BarData(Colors.orange, 8, "상처"), //상처
  ];

  @override
  State<BarChartSample7> createState() => _BarChartSample7State();
}

class _BarChartSample7State extends State<BarChartSample7> {
  GraphType currentGraphType = GraphType.abs; // 기본은 텍스트 감정
  String message = '';
  String emotionString = '';

  BarChartGroupData generateBarGroup(
      int x,
      Color color,
      double value,
      ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 6,
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    // initState에서 한 번만 문자열 변환 실행

  }

  @override
  Widget build(BuildContext context) {
    // print('대표 감정:  ${widget.model[0].representEmotion}');
    // print('텍스트 감정:  ${widget.model[0].textCount}');
    // print('음성 감정:  ${widget.model[0].speechCount}');
    // print('통합 감정:  ${widget.model[0].absTextCount}');

    // 리스트를 문자열로 변환
    //String emotionsString = widget.model[0].absTextCount.join(', ');
    //print('변환 값: $emotionsString');

    if(emotionString=='')
    {
      emotionString = widget.model[0].representEmotion.join(', ');
      // 한 달 대표 감정 보내주기
      sendRepEmo(UserManager().getUserId()!, emotionString);
      //print('변환 값: $emotionString');
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap( // 수정: Row 대신 Wrap 사용
              alignment: WrapAlignment.spaceEvenly,
              spacing: 8,
              children: [
                IconButton(
                  icon: Icon(Icons.auto_graph_rounded, size: 24), // 아이콘과 크기 설정
                  onPressed: () {
                    setState(() {
                      currentGraphType = GraphType.abs;
                    });
                  },
                  tooltip: '텍스트 감정', // 툴팁 추가
                ),
                IconButton(
                  icon: Icon(Icons.text_fields_rounded, size: 24), // 아이콘과 크기 설정
                  onPressed: () {
                    setState(() {
                      currentGraphType = GraphType.text;
                    });
                  },
                  tooltip: '음성 감정', // 툴팁 추가
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_voice_rounded, size: 24), // 아이콘과 크기 설정
                  onPressed: () {
                    setState(() {
                      currentGraphType = GraphType.voice;
                    });
                  },
                  tooltip: '통합 감정', // 툴팁 추가
                ),
              ],
            ),
            SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.0,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  borderData: FlBorderData(
                    show: true,
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: AppColors.borderColor.withOpacity(0.2),
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: AxisTitles(
                      drawBelowEverything: true,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            textAlign: TextAlign.left,
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 80,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          List<String> titles = ["중립", "슬픔", "분노", "행복", "불안", "당황", "상처"];
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: _IconWidget(
                              color: widget.dataList[index].color,
                              isSelected: touchedGroupIndex == index,
                              iconText: titles[index],
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.borderColor.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  barGroups: widget.dataList.asMap().entries.map((e) {
                    final index = e.key;
                    final data = e.value;
                    double value;
                    switch (currentGraphType) {
                      case GraphType.text:
                        value = widget.model[0].textCount[index].toDouble();
                        break;
                      case GraphType.voice:
                        value = widget.model[0].speechCount[index].toDouble();
                        break;
                      case GraphType.abs:
                        value = widget.model[0].absTextCount[index].toDouble();
                        break;
                    }
                    return generateBarGroup(
                      index,
                      data.color,
                      value,
                    );
                  }).toList(),
                  maxY: 20,
                  barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.black54.withOpacity(0.8),
                      tooltipMargin: 0,
                      getTooltipItem: (
                          BarChartGroupData group,
                          int groupIndex,
                          BarChartRodData rod,
                          int rodIndex,
                          ) {
                        // 터치된 그래프 인덱스에 해당하는 x축 텍스트를 가져오기!
                        final iconText = widget.dataList[groupIndex].iconText;
                        return BarTooltipItem(
                          '$iconText ${rod.toY.toString()}', // 막대 높이와 아이콘 텍스트를 함께 표시
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            color: rod.color,
                            fontSize: 18,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 12,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    touchCallback: (event, response) {
                      if (event.isInterestedForInteractions &&
                          response != null &&
                          response.spot != null) {
                        setState(() {
                          touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                        });
                      } else {
                        setState(() {
                          touchedGroupIndex = -1; // 막대가 터치되지 않았을 때 인덱스를 초기화
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  // 한 달 피드백 <- 한 달 대표감정 보내기
  Future<MonthFeedbackModel> sendRepEmo(String userId, String month_max_emotion) async {
    final response = await http.post(
      Uri.parse('$ip/month_feedback_api/monthfeedback'),
      headers:{'Content-Type': 'application/json',},
      body: jsonEncode({
        "userId": userId,
        "month_max_emotion": month_max_emotion,
      }),
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      MonthFeedbackModel monthRepEmo = MonthFeedbackModel.fromJson(data);
      if(mounted){
        setState(() {
          message = monthRepEmo.feedback;
          print('message: $message');
        });
      }
      return monthRepEmo;
    }
    else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      throw Exception('Error: ${data['message']}');
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
}

class _BarData {
  const _BarData(this.color, this.value, this.iconText);
  final Color color;
  final double value;
  final String iconText; // x축 감정 이름
}

class _IconWidget extends ImplicitlyAnimatedWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
    this.iconText = '', // 아이콘 텍스트를 추가하고 기본값으로 빈 문자열을 설정합니다.
  }) : super(duration: const Duration(milliseconds: 300));

  final Color color;
  final bool isSelected;
  final String iconText; // 아이콘 텍스트를 저장하는 변수입니다.

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _IconWidgetState();
}


class _IconWidgetState extends AnimatedWidgetBaseState<_IconWidget> {
  Tween<double>? _rotationTween;

  @override
  Widget build(BuildContext context) {
    final rotation = math.pi * 4 * _rotationTween!.evaluate(animation);
    final scale = 1 + _rotationTween!.evaluate(animation) * 0.5;
    return Column(
      children: [
        Transform(
          transform: Matrix4.rotationZ(rotation).scaled(scale, scale),
          origin: const Offset(14, 14),
          child: Icon(
            widget.isSelected ? Icons.face_retouching_natural : Icons.face,
            color: widget.color,
            size: 28,
          ),
        ),
        Text(widget.iconText), // 아이콘 텍스트를 표시합니다.
      ],
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rotationTween = visitor(
      _rotationTween,
      widget.isSelected ? 1.0 : 0.0,
          (dynamic value) => Tween<double>(
        begin: value as double,
        end: widget.isSelected ? 1.0 : 0.0,
      ),
    ) as Tween<double>?;
  }
}