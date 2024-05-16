import 'package:capstone_frontend/screen/statistic/model/month_emotion_resp_model.dart';
import 'package:flutter/material.dart';

class StatisticViewModel extends ChangeNotifier {
  String _message = '';
  String _repEmo = '';
  List<DiaryMonthModel> _diaryMonthModel = [];

  String get message => _message;
  String get repEmo => _repEmo;
  List<DiaryMonthModel> get diaryMonthModel => _diaryMonthModel;

  void setMessage(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }

  void setRepEmo(String newEmo) {
    _repEmo = newEmo;
    notifyListeners();
  }

  void setDiaryMonthModel(List<DiaryMonthModel> newModel) {
    _diaryMonthModel = newModel;
    notifyListeners();
  }
}
