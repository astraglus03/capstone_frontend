import 'package:capstone_frontend/home/models/diary_model.dart';
import 'package:capstone_frontend/home/repository/diary_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final diaryDetailProvider = Provider.family<DiaryModel?, String>((ref, id) {
  final state = ref.watch(diaryProvider);
  return state.diaries.firstWhere(
    (diary) => diary.id == id,
    orElse: () => DiaryModel(),
  );
});

final diaryProvider = StateNotifierProvider<DiaryStateNotifier, DiaryState>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  return DiaryStateNotifier(repository: repository);
});

class DiaryState {
  final bool isLoading;
  final String? error;
  final List<DiaryModel> diaries;
  final DateTime currentDate;
  final DiaryModel? selectedDiary;

  DiaryState({
    this.isLoading = false,
    this.error,
    this.diaries = const [],
    DateTime? currentDate,
    this.selectedDiary,
  }) : currentDate = currentDate ?? DateTime.now();

  DiaryState copyWith({
    bool? isLoading,
    String? error,
    List<DiaryModel>? diaries,
    DateTime? currentDate,
    DiaryModel? selectedDiary,
  }) {
    return DiaryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      diaries: diaries ?? this.diaries,
      currentDate: currentDate ?? this.currentDate,
      selectedDiary: selectedDiary ?? this.selectedDiary,
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
      // API 연동 시 사용할 코드
      // final yearMonth = DateFormat('yyyy-MM').format(state.currentDate);
      // final diaries = await repository.getMonthDiaries(yearMonth);

      // 더미 데이터 사용
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

  Future<void> getDetailDiary(String id) async {
    try {
      final diary = state.diaries.firstWhere(
        (diary) => diary.id == id,
        orElse: () => DiaryModel(),
      );
      
      if (diary.id != null) {
        state = state.copyWith(selectedDiary: diary);
      } else {
        state = state.copyWith(
          error: '해당 일기를 찾을 수 없습니다.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: '일기 상세 정보를 불러오는데 실패했습니다.',
      );
    }
  }

  void updateCurrentDate(DateTime newDate) {
    state = state.copyWith(currentDate: newDate);
    getDiaries();
  }
}
