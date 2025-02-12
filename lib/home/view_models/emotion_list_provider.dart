import 'package:capstone_frontend/home/models/emotion_list_model.dart';
import 'package:capstone_frontend/home/repository/emotion_list_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final emotionListProvider = StateNotifierProvider<EmotionListStateNotifier, EmotionListState>((ref) {
  final repository = ref.watch(emotionRepositoryProvider);
  return EmotionListStateNotifier(repository: repository);
});

class EmotionListState {
  final bool isLoading;
  final String? error;
  final List<String> emotions;

  EmotionListState({
    this.isLoading = false,
    this.error,
    this.emotions = const [],
  });

  EmotionListState copyWith({
    bool? isLoading,
    String? error,
    List<String>? emotions,
  }) {
    return EmotionListState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      emotions: emotions ?? this.emotions,
    );
  }
}

class EmotionListStateNotifier extends StateNotifier<EmotionListState> {
  final EmotionRepository repository;

  EmotionListStateNotifier({
    required this.repository,
  }) : super(EmotionListState()) {
    getMonthEmotions();
  }

  Future<void> getMonthEmotions() async {
    state = state.copyWith(isLoading: true);
    try {
      // 현재 날짜로부터 yearMonth 포맷(YYYY-MM) 생성
      final now = DateTime.now();
      final yearMonth = DateFormat('yyyy-MM').format(now);

      // API 연동 시 사용할 코드
      // final response = await repository.getMonthBestEmotions(yearMonth: yearMonth);
      // final emotions = response.emotionList;

      // 더미 데이터 사용
      final response = await EmotionRepository.getDummyEmotions();
      final emotions = response.emotionList;
      
      state = state.copyWith(
        isLoading: false,
        emotions: emotions,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '감정 데이터를 불러오는데 실패했습니다.',
      );
    }
  }
}
