import 'package:capstone_frontend/home/models/diary_model.dart';
import 'package:capstone_frontend/home/repository/diary_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// 일기 목록 관리
final diaryProvider = StateNotifierProvider<DiaryStateNotifier, DiaryState>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  return DiaryStateNotifier(repository: repository);
});

class DiaryState {
  final bool isLoading;
  final String? error;
  final List<DiaryModel> diaries;
  final DateTime currentDate;

  DiaryState({
    this.isLoading = false,
    this.error,
    this.diaries = const [],
    DateTime? currentDate,
  }) : currentDate = currentDate ?? DateTime.now();

  DiaryState copyWith({
    bool? isLoading,
    String? error,
    List<DiaryModel>? diaries,
    DateTime? currentDate,
  }) {
    return DiaryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      diaries: diaries ?? this.diaries,
      currentDate: currentDate ?? this.currentDate,
    );
  }
}

class DiaryStateNotifier extends StateNotifier<DiaryState> {
  final DiaryRepository repository;

  DiaryStateNotifier({
    required this.repository,
  }) : super(DiaryState()) {
    getDiaries();
  }

  Future<void> getDiaries() async {
    state = state.copyWith(isLoading: true);
    try {
      final diaries = await DiaryRepository.getDummyDiaries(state.currentDate);
      state = state.copyWith(
        isLoading: false,
        diaries: diaries,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '일기를 불러오는데 실패했습니다.',
      );
    }
  }

  void updateCurrentDate(DateTime newDate) {
    state = state.copyWith(currentDate: newDate);
    getDiaries();
  }
}
