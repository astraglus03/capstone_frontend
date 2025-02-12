import 'dart:convert';

import 'package:capstone_frontend/common/const/const.dart';
import 'package:capstone_frontend/common/dio/dio.dart';
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
  Future<List<DiaryModel>> getMonthDiaries(
    @Path('yearMonth') String yearMonth,
  );

  // 임시 구현 (서버 연동 전까지 사용)
  static Future<List<DiaryModel>> getDummyDiaries(DateTime currentDate) async {
    await Future.delayed(const Duration(seconds: 1)); // 로딩 시뮬레이션

    // 더미 이미지 데이터 (base64로 인코딩된 작은 이미지)
    final dummyImageBytes = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=='
    );

    final dummyDiaries = [
      DiaryModel(
        id: '1',
        date: DateTime(2025, 2, 12),  // 2025년 2월 12일
        content: '오늘은 정말 특별한 하루였어. 아침에 일어나자마자 퐁당이와 대화를 나눴는데, 요즘 내가 겪고 있는 취업 스트레스에 대해 이야기했어. 면접 준비하면서 느끼는 불안감, 그리고 다른 지원자들과 비교하면서 생기는 자격지심 같은 것들... 퐁당이는 내 이야기를 정말 잘 들어주더라. 특히 "지금까지 해온 노력들이 의미없는 게 아니에요. 각자의 페이스대로 성장하는 거니까요"라는 말에 큰 위로를 받았어.\n\n오후에는 퐁당이의 제안대로 잠시 공부는 접어두고 친구들과 카페에 갔어. 오랜만에 수다도 떨고, 맛있는 디저트도 먹으면서 기분 전환을 했지. 역시 퐁당이 말이 맞았어. 잠깐의 휴식이 새로운 에너지가 되는 것 같아.',
        feedback: '당신의 감정을 잘 표현해주셔서 감사합니다. 취업 준비 과정에서 느끼는 스트레스와 불안감은 매우 자연스러운 감정이에요. 특히 자신과 다른 사람을 비교하면서 느끼는 압박감이 크셨을 텐데, 그런 감정을 잘 인식하고 표현하신 것이 인상적이에요.\n\n휴식을 취하고 친구들과 시간을 보내신 것은 정말 현명한 선택이었습니다. 지속적인 스트레스 상황에서는 적절한 휴식과 기분 전환이 매우 중요하거든요. 이런 식으로 자신의 감정을 잘 살피고, 때로는 쉬어가는 것이 장기적으로 더 효과적인 취업 준비가 될 수 있어요.\n\n앞으로도 힘들 때면 언제든 이야기를 나눠요. 당신의 이야기를 듣고 함께 고민하면서 해결책을 찾아가는 것이 제 역할이니까요. 항상 당신 곁에서 응원하고 있다는 걸 잊지 마세요!',
        absEmotion: ['걱정', '슬픔', '중립', '행복'],
        image: dummyImageBytes,
      ),
      DiaryModel(
        id: '2',
        date: DateTime(2025, 2, 14),  // 2025년 2월 14일
        content: '오늘은 아침부터 기분이 좋지 않았어. 어제 늦게까지 공부하느라 피곤한데, 아침에 갑자기 교수님께서 과제 제출 기한을 앞당기신다고 하셔서 당황스러웠어. 퐁당이한테 이 상황을 털어놓으니까, 우선 심호흡부터 하자고 제안해줬어.\n\n퐁당이의 제안대로 잠시 눈을 감고 깊은 호흡을 하면서 마음을 가라앉혔어. 그리고 함께 우선순위를 정하고 시간 계획을 세워봤지. 처음에는 불가능해 보였던 일이, 차근차근 계획을 세우고 나니까 조금은 할 만해 보이더라.\n\n저녁에는 퐁당이가 추천해준 대로 잠깐 산책을 했어. 선선한 바람을 맞으면서 걷다 보니 머리도 맑아지고, 새로운 아이디어도 떠올랐어. 결국 오늘 과제의 절반 정도를 완성했는데, 생각보다 잘 풀려서 다행이야.',
        feedback: '갑작스러운 상황 변화에 당황스러우셨을 텐데, 그 순간에도 차분하게 대처하려 노력하신 모습이 정말 멋져요. 특히 심호흡을 통해 먼저 감정을 진정시키고, 계획을 세워 문제를 해결하려 하신 것은 매우 현명한 접근이었습니다.\n\n스트레스 상황에서 산책을 선택하신 것도 훌륭한 결정이었어요. 신체 활동은 스트레스 해소에 매우 효과적이며, 실제로 새로운 아이디어가 떠오르는 데도 도움이 되었죠. 이렇게 어려운 상황에서도 긍정적인 방법을 찾아 대처하시는 모습이 인상적입니다.\n\n과제의 절반을 완성하신 것은 정말 대단한 성과예요. 남은 과제도 오늘처럼 차근차근 진행하시면 좋은 결과가 있을 거예요. 힘들 때마다 오늘을 떠올려보세요. 당신은 충분히 잘 해내고 있답니다.',
        absEmotion: ['당황', '걱정', '중립', '행복'],
        image: dummyImageBytes,
      ),
      DiaryModel(
        id: '3',
        date: DateTime(2025, 3, 13),  // 2025년 3월 13일
        content: '오늘은 정말 기쁜 일이 있었어! 3개월 동안 준비해온 프로젝트 발표가 있었는데, 교수님께서 내 발표를 굉장히 칭찬해주셨어. 특히 문제 해결 방식이 참신하다고 하시면서, 다른 학생들한테도 좋은 예시가 될 거라고 말씀해주셨어. 이 소식을 제일 먼저 퐁당이한테 전했는데, 정말 진심으로 기뻐해주는 게 느껴졌어. 그동안 프로젝트 준비하면서 힘들 때마다 퐁당이가 해준 조언들이 많은 도움이 됐어. 특히 "실패해도 괜찮아요, 그게 더 큰 배움이 될 수 있어요"라고 해준 말이 큰 용기가 됐었지.\n\n오늘 저녁에는 가족들이랑 맛있는 저녁을 먹으면서 축하를 받았어. 부모님도 내가 열심히 준비한 걸 아시니까 더 기뻐하시더라. 이런 날이 있어서 그동안의 힘들었던 시간들이 다 보상받는 것 같아.',
        feedback: '축하드립니다! 3개월간의 노력이 이렇게 좋은 결실을 맺게 되어 정말 기쁩니다. 교수님의 칭찬은 당신의 노력과 창의성을 인정받은 증거라고 할 수 있겠네요.\n\n프로젝트를 준비하는 동안 여러 어려움이 있었을 텐데, 그때마다 포기하지 않고 끝까지 최선을 다하신 점이 정말 자랑스러워요. 특히 새로운 시도를 두려워하지 않고 참신한 해결 방식을 제시하신 것은 큰 용기가 필요한 일이었을 텐데, 멋지게 해내셨네요.\n\n가족들과 함께 기쁨을 나누신 것도 너무 좋습니다. 이런 특별한 순간들이 앞으로의 도전에도 큰 힘이 될 거예요. 당신의 잠재력은 무궁무진하다는 걸 잊지 마세요. 앞으로도 이런 기쁜 소식들을 많이 나눌 수 있기를 기대하고 있을게요!',
        absEmotion: ['행복', '행복', '중립', '기쁨'],
        image: dummyImageBytes,
      ),
    ];

    return dummyDiaries.where((diary) {
      return diary.date?.month == currentDate.month && 
             diary.date?.year == currentDate.year;
    }).toList();
  }
}
