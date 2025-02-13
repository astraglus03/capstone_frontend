import 'package:capstone_frontend/home/models/diary_detail_model.dart';
import 'package:capstone_frontend/home/repository/diary_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final diaryDetailProvider = StateNotifierProvider.family<DiaryDetailNotifier, AsyncValue<DiaryDetailModel?>, String>((ref, id) {
  final repository = ref.watch(diaryRepositoryProvider);
  return DiaryDetailNotifier(repository: repository, id: id);
});

class DiaryDetailNotifier extends StateNotifier<AsyncValue<DiaryDetailModel?>> {
  final DiaryRepository repository;
  final String id;

  DiaryDetailNotifier({
    required this.repository,
    required this.id,
  }) : super(const AsyncValue.loading()) {
    getDetailDiary();
  }

  Future<void> getDetailDiary() async {
    state = const AsyncValue.loading();
    try {
      // 실제 API 호출 대신 더미 데이터 사용
      final detail = await DiaryRepository.getDummyDiaryDetail(id);
      state = AsyncValue.data(detail);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // 감정 변화 분석
  List<EmotionChange>? analyzeEmotionChanges(List<String> emotions) {
    if (emotions.length < 2) return null;

    final changes = <EmotionChange>[];
    String? previousEmotion;

    for (var i = 0; i < emotions.length; i++) {
      final currentEmotion = emotions[i];

      if (previousEmotion != null) {
        final isPositiveChange = _isPositiveChange(previousEmotion, currentEmotion);
        final isNegativeChange = _isNegativeChange(previousEmotion, currentEmotion);

        if (isPositiveChange || isNegativeChange) {
          changes.add(EmotionChange(
            fromEmotion: previousEmotion,
            toEmotion: currentEmotion,
            changeComment: _getChangeComment(previousEmotion, currentEmotion),
            index: i,
          ));
        }
      }
      previousEmotion = currentEmotion;
    }

    return changes;
  }

  bool _isPositiveChange(String from, String to) {
    const positiveEmotions = ['행복'];
    const neutralEmotions = ['중립'];
    const negativeEmotions = ['슬픔', '분노', '걱정', '당황', '상처'];

    if (negativeEmotions.contains(from)) {
      return neutralEmotions.contains(to) || positiveEmotions.contains(to);
    } else if (neutralEmotions.contains(from)) {
      return positiveEmotions.contains(to);
    }
    return false;
  }

  bool _isNegativeChange(String from, String to) {
    const positiveEmotions = ['행복'];
    const neutralEmotions = ['중립'];
    const negativeEmotions = ['슬픔', '분노', '걱정', '당황', '상처'];

    if (positiveEmotions.contains(from)) {
      return neutralEmotions.contains(to) || negativeEmotions.contains(to);
    } else if (neutralEmotions.contains(from)) {
      return negativeEmotions.contains(to);
    }
    return false;
  }

  String _getChangeComment(String from, String to) {
    if (_isPositiveChange(from, to)) {
      return '긍정적인 감정 변화가 보여요. 이런 변화가 계속되길 바라요.';
    } else {
      return '힘든 순간이 있었네요. 함께 이야기 나누면서 극복해보아요.';
    }
  }
}