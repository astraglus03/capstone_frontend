import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class EmotionChangeChart extends StatefulWidget {
  final List<String> absEmo; // 통합감정
  final int circumstance;    // case
  final List<String> changeEmotion; // 감정변화
  final List<List<String>> small_emotion; // 소분류 감정변화
  final List<String> chatResponse; // 챗봇에게 받은 피드백
  final List<String> changeComment; // 감정 소분류별 코멘트

  const EmotionChangeChart({
    Key? key,
    required this.absEmo,
    required this.circumstance,
    required this.changeEmotion,
    required this.small_emotion,
    required this.chatResponse,
    required this.changeComment,
  }) : super(key: key);

  @override
  State<EmotionChangeChart> createState() => EmotionChangeChartState();
}

class EmotionChangeChartState extends State<EmotionChangeChart> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> emotionWidgets = [];
    List<String> emotionChanges = [];
    for(int i=0; i<widget.changeEmotion.length; i++){
      String imagePath2;
      switch(widget.changeEmotion[i]){
        case "중립":
          imagePath2 = 'asset/emotion/neutral.png';
          break;
        case "슬픔":
          imagePath2 = 'asset/emotion/sad.png';
          break;
        case "분노":
          imagePath2 = 'asset/emotion/angry.png';
          break;
        case "행복":
          imagePath2 = 'asset/emotion/happy.png';
          break;
        case "당황":
          imagePath2 = 'asset/emotion/embarrassed.png';
          break;
        case "상처":
          imagePath2 = 'asset/emotion/hurt.png';
          break;
        case "불안":
          imagePath2 = 'asset/emotion/anxious.png';
          break;
        default:
          imagePath2 = 'asset/view 1.webp';
      }
      emotionChanges.add(imagePath2);
    }
    for (int i = 0; i < widget.absEmo.length; i++) {
      String imagePath;
      switch (widget.absEmo[i]) {
        case "중립":
          imagePath = 'asset/emotion/neutral.png';
          break;
        case "슬픔":
          imagePath = 'asset/emotion/sad.png';
          break;
        case "분노":
          imagePath = 'asset/emotion/angry.png';
          break;
        case "행복":
          imagePath = 'asset/emotion/happy.png';
          break;
        case "당황":
          imagePath = 'asset/emotion/embarrassed.png';
          break;
        case "상처":
          imagePath = 'asset/emotion/hurt.png';
          break;
        case "불안":
          imagePath = 'asset/emotion/anxious.png';
          break;
        default:
          imagePath = 'asset/emotion/view 1.webp';
      }

      emotionWidgets.add(
        Padding(
          padding: const EdgeInsets.all(2.8),
          child: Container(
            width: 35, // 가로 너비
            height: 75, // 세로 높이
            child: Image.asset(
              imagePath,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      );

      // 감정이 부정에서 긍정으로 변화할 때만 표시
      if (widget.circumstance == 1) {
        if (i < widget.absEmo.length - 1 &&
            (widget.absEmo[i] == "불안" ||
                widget.absEmo[i] == "상처" ||
                widget.absEmo[i] == "슬픔" ||
                widget.absEmo[i] == "당황" ||
                widget.absEmo[i] == "분노") &&
            (widget.absEmo[i + 1] == "행복" || widget.absEmo[i + 1] == "중립")) {

          emotionWidgets.add(
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  print('widgetCounter: $i');
                  print('감정 소분류: ${widget.small_emotion}');

                  final iconBox = context.findRenderObject() as RenderBox;
                  final iconPosition = iconBox.localToGlobal(Offset.zero);
                  final overlayEntry = OverlayEntry(
                    builder: (context) => Positioned(
                      left: iconPosition.dx + 100, //left: iconPosition.dx - overlay.size.width / 2 + iconBox.size.width / 2,
                      top: iconPosition.dy -100,  //top: iconPosition.dy - overlay.size.height - 100, // 툴팁 위치 수정하기

                      child: Container(
                        width: 150, // 툴팁의 가로 크기
                        height: 150, // 툴팁의 세로 크기
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8), // 반투명한 블랙 배경
                          borderRadius: BorderRadius.circular(8.0), // 모서리를 둥글게 만듦
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          widget.chatResponse[i], // 클릭된 위젯의 인덱스에 해당하는 chatResponse 값을 표시
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                  Overlay.of(context)!.insert(overlayEntry);
                  // Remove the tooltip after a short delay (e.g., 2 seconds)
                  Future.delayed(Duration(seconds: 3), () {
                    overlayEntry.remove();
                  });
                },
                onTapUp: (details) {
                  print('onTapUp');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black, // 원하는 배경 색으로 설정
                    borderRadius: BorderRadius.circular(12), // 모서리를 둥글게 설정, 12를 원하는 값으로 변경
                  ),
                  width: 10,
                  height: 30, // 세로로 긴 모양
                ),
              ),
            ),
          );
        }
      }

    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(' 감정 변화',
            style: TextStyle(
              fontSize: 15,
              //fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // 원하는 색상으로 변경하세요
            ),
          ),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal, // 가로 방향으로 스크롤 가능하게 설정
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // 원하는 배경 색으로 설정
                borderRadius: BorderRadius.circular(12), // 모서리를 둥글게 설정, 12를 원하는 값으로 변경
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: emotionWidgets,
              ),
            )
        ),
        const SizedBox(height: 10),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text(' 최종 감정 변화',
            style: TextStyle(
              fontSize: 15,
              //fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // 원하는 색상으로 변경하세요
            ),),
        ),
        // 최종 감정 변화 코멘트                                                    m
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // 원하는 배경 색으로 설정
            borderRadius: BorderRadius.circular(12), // 모서리를 둥글게 설정, 12를 원하는 값으로 변경
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width:35,
                    height: 75,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(emotionChanges[0]), // 사건 감정
                        // image: AssetImage('asset/emotion/happy.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_right_rounded, size: 70, color: Colors.black),
                  SizedBox(width: 10,),
                  Container(
                    width:35,
                    height: 75,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(emotionChanges[1]), // 최종 감정
                        // image: AssetImage('asset/emotion/neutral.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ],
              ),
              Text(widget.changeComment[0]),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        if(widget.circumstance == 1)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(' 대화 속 감정 변화',
              style: TextStyle(
                fontSize: 15,
                //fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // 원하는 색상으로 변경하세요
              ),),
          ),

        // 감정 소분류
        if(widget.circumstance == 1)
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // 원하는 배경 색으로 설정
              borderRadius: BorderRadius.circular(12), // 모서리를 둥글게 설정, 12를 원하는 값으로 변경
            ),
            child: Column(
              children:widget.small_emotion.asMap().entries.map((entry) {
                int index = entry.key+1;
                List<String> emotions = entry.value;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 35,
                          height: 75,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(getImagePath(emotions[0])), // 부정 감정
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_right_rounded, size: 70, color: Colors.black),
                        SizedBox(width: 10),
                        Container(
                          width: 35,
                          height: 75,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(getImagePath(emotions[1])), // 긍정 감정
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(widget.changeComment[index]),
                  ],
                );
              }).toList(),

            ),
          ),
      ],
    );
  }



  String getImagePath(String emotion) {
    switch (emotion) {
      case "중립":
        return 'asset/emotion/neutral.png';
      case "슬픔":
        return 'asset/emotion/sad.png';
      case "분노":
        return 'asset/emotion/angry.png';
      case "행복":
        return 'asset/emotion/happy.png';
      case "당황":
        return 'asset/emotion/embarrassed.png';
      case "상처":
        return 'asset/emotion/hurt.png';
      case "불안":
        return 'asset/emotion/anxious.png';
      default:
        return 'asset/emotion/view 1.webp';
    }
  }

}
