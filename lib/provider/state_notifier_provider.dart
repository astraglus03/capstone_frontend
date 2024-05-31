import 'package:capstone_frontend/const/api_utils.dart';
import 'package:capstone_frontend/screen/statistic/model/diary_model.dart';
import 'package:capstone_frontend/screen/statistic/model/month_emotion_resp_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final monthListProvider = StateNotifierProvider<MonthListNotifier, AsyncValue<List<DiaryModel>>>((ref) => MonthListNotifier());
final representMonthEmotionProvider = StateNotifierProvider<RepresentNotifier, AsyncValue<DiaryMonthModel>>((ref) => RepresentNotifier());
final dio = Dio();

class MonthListNotifier extends StateNotifier<AsyncValue<List<DiaryModel>>> {

  MonthListNotifier() : super(AsyncValue.loading());

  void fetchDiariesForMonth(String userId, String month) async {
      try {
        final diaries = await _fetchDiariesForMonth(userId, month);
        state = AsyncValue.data(diaries);
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    }

  Future<List<DiaryModel>> _fetchDiariesForMonth(String userId, String month) async {
    final resp = await dio.post('$ip/Search_Diary_api/searchdiary', data: {
      'userId': userId,
      'month' : month,
      'date': 'None',
      'limit': 'None',
    });
    print('여기부분${resp.data}');

    if (resp.statusCode == 200) {
      return (resp.data as List).map((item) => DiaryModel.fromJson(item)).toList();
    } else if (resp.statusCode == 404) {
      // 로그를 남기고 빈 리스트 반환
      print("No data available for the month: $month");
      return [];
    } else {
      throw DioError(
        requestOptions: resp.requestOptions,
        error: 'Failed to load data, status code: ${resp.statusCode}',
      );
    }
  }
}

class RepresentNotifier extends StateNotifier<AsyncValue<DiaryMonthModel>> {

  RepresentNotifier() : super(AsyncValue.loading()){
    _initialize();
  }

  void _initialize() {
    final String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
    fetchRepresentMonthEmotion(UserManager().getUserId().toString(), currentMonth);
  }


  void fetchRepresentMonthEmotion(String userId, String month) async {
      try {
        final monthEmotion = await _fetchRepresentMonthEmotion(userId, month);
        state = AsyncValue.data(monthEmotion);
      } catch (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      }
    }

  Future<DiaryMonthModel> _fetchRepresentMonthEmotion(String userId, String month) async {
    final resp = await dio.post('$ip/Count_Month_Emotion/countmonthemotion', data: {
      'userId': userId,
      'date' : 'None',
      'month': month,
      'limit': 'None',
    });
    print('데이터:${resp.data['month_max_emotion']}');

    if (resp.statusCode == 200) {
      print('다이어리다!!${DiaryMonthModel.fromJson(resp.data['month_max_emotion'])}');
      return DiaryMonthModel.fromJson(resp.data['month_max_emotion']);
    }
    else if(resp.statusCode == 404) {
      // 로그를 남기고 빈 리스트 반환
      print("No data available for the month: $month");
      return DiaryMonthModel(
        textCount: [],
        speechCount: [],
        absTextCount: [],
        representEmotion: [],
        cases: [],
        sendComment: '',
      );
    } else {
      throw DioError(
        requestOptions: resp.requestOptions,
        error: 'Failed to load data, status code: ${resp.statusCode}',
      );
    }
  }
}