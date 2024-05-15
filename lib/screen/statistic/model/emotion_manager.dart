import 'package:flutter/material.dart';

class EmotionManager with ChangeNotifier {
  String _repEmo = ''; // 대표 감정 상태 저장

  // 대표 감정 값을 가져오는 getter
  String get repEmo => _repEmo;

  // 대표 감정 값을 설정하는 메소드. 이 메소드가 호출되면 리스너들에게 상태 변경을 알리게 됨.
  void setRepEmo(String newEmo) {
    if (_repEmo != newEmo) {
      _repEmo = newEmo;
      notifyListeners(); // 상태 변경 알림
    }
  }
}
