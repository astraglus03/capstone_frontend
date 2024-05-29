import 'package:flutter/material.dart';

class EmotionChangeChart extends StatefulWidget {
  final List<String> absEmo;
  final int circumstance;
  final List<String> changeEmotion;
  final List<String> chatResponse;

  const EmotionChangeChart({
    Key? key,
    required this.absEmo,
    required this.circumstance,
    required this.changeEmotion,
    required this.chatResponse,
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

      // 감정이 부정에서 긍정으로 주기
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
                // 버튼 클릭 시 동작
                print("Vertical line button clicked!");
              },
              child: Container(
                width: 4,
                height: 30, // 세로로 긴 모양
                color: Colors.black, // 버튼 색상
              ),
            ),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, // 가로 방향으로 스크롤 가능하게 설정
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: emotionWidgets,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width:35,
              height: 75,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(emotionChanges[0]),
                  // image: AssetImage('asset/emotion/happy.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_right_alt, size: 70, color: Colors.black),
            SizedBox(width: 10,),
            Container(
              width:35,
              height: 75,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(emotionChanges[1]),
                  // image: AssetImage('asset/emotion/neutral.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        Text('심종혜 심종혜 심종혜 배재민 배재민 배재민 김건동 김건동 김건동 박지용 박지용 박지용,심종혜 심종혜 심종혜 배재민 배재민 배재민 김건동 김건동 김건동 박지용 박지용 박지용'),
      ],
    );
  }
}
