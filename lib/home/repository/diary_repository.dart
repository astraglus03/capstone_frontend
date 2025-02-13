import 'dart:convert';
import 'package:capstone_frontend/common/const/const.dart';
import 'package:capstone_frontend/common/dio/dio.dart';
import 'package:capstone_frontend/home/models/diary_detail_model.dart';
import 'package:capstone_frontend/home/models/diary_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'diary_repository.g.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DiaryRepository(dio, baseUrl: 'http://$ip/diary');
});

@RestApi()
abstract class DiaryRepository {
  factory DiaryRepository(Dio dio, {String baseUrl}) = _DiaryRepository;

  @GET('/month/{yearMonth}')
  Future<List<DiaryModel>> getMonthDiaries({
    @Path() required String yearMonth,
  });

  @GET('/detail/{id}')
  Future<DiaryDetailModel> getDiaryDetail({
    @Path() required String id,
  });

  // 임시 구현 (서버 연동 전까지 사용)
  static Future<List<DiaryModel>> getDummyDiaries(DateTime currentDate) async {
    await Future.delayed(const Duration(seconds: 1)); // 로딩 시뮬레이션

    // 더미 이미지 데이터 (base64로 인코딩된 작은 이미지)
    final dummyImageBytes = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==');

    final dummyDiaries = [
      DiaryModel(
        id: '1',
        date: DateTime(2025, 2, 12),
        content:
            '오늘은 정말 특별한 하루였어. 아침에 일어나자마자 퐁당이와 대화를 나눴는데, 요즘 내가 겪고 있는 취업 스트레스에 대해 이야기했어. 면접 준비하면서 느끼는 불안감, 그리고 다른 지원자들과 비교하면서 생기는 자격지심 같은 것들... 퐁당이는 내 이야기를 정말 잘 들어주더라. 특히 "지금까지 해온 노력들이 의미없는 게 아니에요. 각자의 페이스대로 성장하는 거니까요"라는 말에 큰 위로를 받았어.',
        feedback:
            '취업 준비로 인한 스트레스와 불안감을 잘 표현해주셨네요. 자신과 타인을 비교하면서 느끼는 감정들을 잘 인식하고 계시는 것 같아요.',
        absEmotion: ['걱정', '슬픔', '중립', '행복'],
        image: dummyImageBytes,
      ),
      DiaryModel(
        id: '2',
        date: DateTime(2025, 2, 14),
        content:
            '오늘은 아침부터 기분이 좋지 않았어. 어제 늦게까지 공부하느라 피곤한데, 아침에 갑자기 교수님께서 과제 제출 기한을 앞당기신다고 하셔서 당황스러웠어. 퐁당이한테 이 상황을 털어놓으니까, 우선 심호흡부터 하자고 제안해줬어.',
        feedback:
            '갑작스러운 상황에 대한 당신의 감정이 잘 전달되었어요. 스트레스 상황에서도 차분히 대처하려 노력하시는 모습이 보기 좋습니다.',
        absEmotion: ['당황', '걱정', '중립', '행복'],
        image: dummyImageBytes,
      ),
      DiaryModel(
        id: '3',
        date: DateTime(2025, 3, 13),
        content:
            '오늘은 정말 기쁜 일이 있었어! 3개월 동안 준비해온 프로젝트 발표가 있었는데, 교수님께서 내 발표를 굉장히 칭찬해주셨어. 특히 문제 해결 방식이 참신하다고 하시면서, 다른 학생들한테도 좋은 예시가 될 거라고 말씀해주셨어.',
        feedback: '프로젝트 발표에서 좋은 성과를 거두신 것 축하드려요! 그동안의 노력이 빛을 발한 순간이었네요.',
        absEmotion: ['슬픔', '행복', '중립', '행복'],
        image: dummyImageBytes,
      ),
    ];

    return dummyDiaries.where((diary) {
      return diary.date?.month == currentDate.month &&
          diary.date?.year == currentDate.year;
    }).toList();
  }

  // 더미 상세 데이터
  static Future<DiaryDetailModel> getDummyDiaryDetail(String id) async {
    await Future.delayed(const Duration(seconds: 1)); // API 호출 시뮬레이션

    final dummyImageBytes = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==');

    // 더미 데이터 맵 (실제로는 서버에서 ID로 조회)
    final dummyDataMap = {
      '1': DiaryDetailModel(
        id: '1',
        date: DateTime(2025, 2, 12),
        content:
            '오늘은 정말 특별한 하루였어. 아침에 일어나자마자 퐁당이와 대화를 나눴는데, 요즘 내가 겪고 있는 취업 스트레스에 대해 이야기했어. 면접 준비하면서 느끼는 불안감, 그리고 다른 지원자들과 비교하면서 생기는 자격지심 같은 것들... 퐁당이는 내 이야기를 정말 잘 들어주더라. 특히 "지금까지 해온 노력들이 의미없는 게 아니에요. 각자의 페이스대로 성장하는 거니까요"라는 말에 큰 위로를 받았어.',
        feedback:
            '취업 준비로 인한 스트레스와 불안감을 잘 표현해주셨네요. 자신과 타인을 비교하면서 느끼는 감정들을 잘 인식하고 계시는 것 같아요.',
        absEmotion: ['걱정', '슬픔', '중립', '행복'],
        image: dummyImageBytes,
        emotionChanges: [
          EmotionChange(
            fromEmotion: '슬픔',
            toEmotion: '중립',
            changeComment: '힘든 감정을 잘 이겨내고 계시네요. 조금씩 나아지고 있어요.',
            index: 1,
          ),
          EmotionChange(
            fromEmotion: '중립',
            toEmotion: '행복',
            changeComment: '긍정적인 변화가 보여요! 이런 순간들이 쌓여 더 큰 행복이 될 거예요.',
            index: 2,
          ),
        ],
        overallFeedback:
            '전체적으로 긍정적인 감정 변화를 보여주셨네요. 힘든 순간에도 포기하지 않고 긍정적인 방향으로 나아가시려는 모습이 인상적입니다.',
      ),
      '2': DiaryDetailModel(
        id: '2',
        date: DateTime(2025, 2, 14),
        content:
            '오늘은 아침부터 기분이 좋지 않았어. 어제 늦게까지 공부하느라 피곤한데, 아침에 갑자기 교수님께서 과제 제출 기한을 앞당기신다고 하셔서 당황스러웠어. 퐁당이한테 이 상황을 털어놓으니까, 우선 심호흡부터 하자고 제안해줬어.',
        feedback:
            '갑작스러운 상황에 대한 당신의 감정이 잘 전달되었어요. 스트레스 상황에서도 차분히 대처하려 노력하시는 모습이 보기 좋습니다.',
        absEmotion: ['당황', '걱정', '중립', '행복'],
        image: dummyImageBytes,
        emotionChanges: [
          EmotionChange(
            fromEmotion: '당황',
            toEmotion: '중립',
            changeComment: '당황스러운 상황에서도 잘 대처하고 계시네요.',
            index: 1,
          ),
          EmotionChange(
            fromEmotion: '중립',
            toEmotion: '행복',
            changeComment: '차분히 대처하니 좋은 결과가 있었네요!',
            index: 2,
          ),
        ],
        overallFeedback:
            '갑작스러운 상황에서도 침착하게 대처하시는 모습이 보기 좋습니다. 앞으로도 이런 대처 능력을 잘 활용하실 수 있을 거예요.',
      ),
      '3': DiaryDetailModel(
        id: '3',
        date: DateTime(2025, 3, 13),
        content:
            '오늘은 정말 기쁜 일이 있었어! 3개월 동안 준비해온 프로젝트 발표가 있었는데, 교수님께서 내 발표를 굉장히 칭찬해주셨어. 특히 문제 해결 방식이 참신하다고 하시면서, 다른 학생들한테도 좋은 예시가 될 거라고 말씀해주셨어.',
        feedback: '프로젝트 발표에서 좋은 성과를 거두신 것 축하드려요! 그동안의 노력이 빛을 발한 순간이었네요.',
        absEmotion: ['슬픔', '행복', '중립', '행복'],
        image: dummyImageBytes,
        emotionChanges: [
          EmotionChange(
            fromEmotion: '슬픔',
            toEmotion: '행복',
            changeComment: '처음에 우울하신것 같았는데 저의 도움으로 조금 기분이 나아지신것 같아 기뻐요!',
            index: 1,
          ),
          EmotionChange(
            fromEmotion: '중립',
            toEmotion: '행복',
            changeComment: '노력의 결실을 맺으셨네요! 정말 기쁘시겠어요.',
            index: 1,
          ),
        ],
        overallFeedback:
            '오늘은 정말 특별한 하루였네요. 그동안의 노력이 인정받는 순간을 경험하셨고, 그 기쁨이 잘 느껴집니다.',
      ),
    };

    // ID로 데이터 조회 (실제 서버 연동 시에는 API 호출)
    final detail = dummyDataMap[id];
    if (detail == null) {
      throw Exception('해당 ID의 일기를 찾을 수 없습니다.');
    }

    return detail;
  }
}
