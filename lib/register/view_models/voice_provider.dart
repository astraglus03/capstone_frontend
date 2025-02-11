import 'package:capstone_frontend/register/models/voice_model.dart';
import 'package:capstone_frontend/register/repository/voice_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

final voiceProvider = StateNotifierProvider<VoiceStateNotifier, VoiceState>((ref) {
  final repository = ref.watch(voiceRepositoryProvider);
  return VoiceStateNotifier(repository: repository);
});

// 상태 클래스
class VoiceState {
  final bool isLoading;
  final String? error;
  final List<bool> completedIndices;
  final int currentIndex;
  final bool isAllCompleted;
  final bool isRecording;
  final String? currentPath;

  VoiceState({
    this.isLoading = false,
    this.error,
    List<bool>? completedIndices,
    this.currentIndex = 0,
    this.isAllCompleted = false,
    this.isRecording = false,
    this.currentPath,
  }) : completedIndices = completedIndices ?? List.filled(5, false);

  VoiceState copyWith({
    bool? isLoading,
    String? error,
    List<bool>? completedIndices,
    int? currentIndex,
    bool? isAllCompleted,
    bool? isRecording,
    String? currentPath,
  }) {
    return VoiceState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      completedIndices: completedIndices ?? this.completedIndices,
      currentIndex: currentIndex ?? this.currentIndex,
      isAllCompleted: isAllCompleted ?? this.isAllCompleted,
      isRecording: isRecording ?? this.isRecording,
      currentPath: currentPath ?? this.currentPath,
    );
  }
}

class VoiceStateNotifier extends StateNotifier<VoiceState> {
  final VoiceRepository repository;
  final _audioRecorder = Record();

  VoiceStateNotifier({
    required this.repository,
  }) : super(VoiceState()) {
    checkVoiceStatus();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    try {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        state = state.copyWith(
          error: '마이크 권한이 필요합니다. 설정에서 권한을 허용해주세요.',
        );
        return;
      }
      
      // iOS에서는 prepare 호출이 필요할 수 있음
      await _audioRecorder.start(encoder: AudioEncoder.aacLc);
      await _audioRecorder.stop();
    } catch (e) {
      state = state.copyWith(
        error: '녹음기를 초기화할 수 없습니다: $e',
      );
    }
  }

  Future<void> startRecording() async {
    if (state.isRecording) return;

    try {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        state = state.copyWith(
          error: '마이크 권한이 필요합니다. 설정에서 권한을 허용해주세요.',
          isRecording: false,
        );
        return;
      }

      await _audioRecorder.start(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
      
      state = state.copyWith(
        isRecording: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: '녹음을 시작할 수 없습니다: $e',
        isRecording: false,
      );
    }
  }

  Future<void> stopRecording() async {
    if (!state.isRecording) return;

    try {
      // 실제 녹음 중단 및 파일 저장 로직 주석 처리
      // final path = await _audioRecorder.stop();
      state = state.copyWith(
        isRecording: false,
        // currentPath: path,
      );

      // 임시 구현: 녹음 파일 없이 바로 다음 단계로 진행
      final newCompletedIndices = [...state.completedIndices];
      newCompletedIndices[state.currentIndex] = true;
      
      final allCompleted = newCompletedIndices.every((completed) => completed);
      
      state = state.copyWith(
        isLoading: false,
        completedIndices: newCompletedIndices,
        currentIndex: allCompleted ? state.currentIndex : state.currentIndex + 1,
        isAllCompleted: allCompleted,
      );

      // if (path != null) {
      //   final file = File(path);
      //   final voice = VoiceModel(
      //     audioFile: file,
      //     index: state.currentIndex,
      //     sentence: VoiceSamples.sentences[state.currentIndex],
      //   );
        
      //   await registerVoice(voice);
      // }
    } catch (e) {
      state = state.copyWith(
        error: '녹음을 중지할 수 없습니다.',
        isRecording: false,
      );
    }
  }

  Future<void> checkVoiceStatus() async {

    // 항상 true로 해놓음 -> 나중에 삭제
    state = state.copyWith(
      isAllCompleted: true
    );

    // // 임시 구현: 항상 음성 등록이 필요한 것으로 처리
    // state = state.copyWith(
    //   isLoading: false,
    //   isAllCompleted: false,
    // );
    
    // try {
    //   final response = await repository.checkVoiceStatus();
    //   state = state.copyWith(
    //     isLoading: false,
    //     isAllCompleted: response.isRegistered,
    //   );
    // } catch (e) {
    //   state = state.copyWith(
    //     isLoading: false,
    //     error: '음성 등록 상태 확인에 실패했습니다.',
    //   );
    // }
  }

  Future<void> registerVoice(VoiceModel voice) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await repository.registerVoice(
        audioFile: voice.audioFile!,
        index: voice.index,
        sentence: voice.sentence,
      );


      if (response.isRegistered) {
        final newCompletedIndices = [...state.completedIndices];
        newCompletedIndices[state.currentIndex] = true;
        
        final allCompleted = newCompletedIndices.every((completed) => completed);
        
        state = state.copyWith(
          isLoading: false,
          completedIndices: newCompletedIndices,
          currentIndex: allCompleted ? state.currentIndex : state.currentIndex + 1,
          isAllCompleted: allCompleted,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: '음성 등록에 실패했습니다.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '음성 등록 중 오류가 발생했습니다.',
      );
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }
} 