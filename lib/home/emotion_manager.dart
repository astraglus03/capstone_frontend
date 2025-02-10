import 'package:flutter/material.dart';

class EmotionManager with ChangeNotifier {
  List _emotionList = []; // 대표 감정 상태 저장

  // 대표 감정 값을 가져오는 getter
  List get repEmo => _emotionList;

  // 대표 감정 값을 설정하는 메소드. 이 메소드가 호출되면 리스너들에게 상태 변경을 알리게 됨.
  void setRepEmo(List newEmoList) {
    if (_emotionList != newEmoList) {
      _emotionList = newEmoList;
      notifyListeners(); // 상태 변경 알림
    }
  }
}
