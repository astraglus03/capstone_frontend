import 'package:capstone_frontend/register/models/voice_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:capstone_frontend/register/view_models/voice_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SampleAudioScreen extends ConsumerStatefulWidget {
  static String get routeName => 'sample_audio';

  const SampleAudioScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SampleAudioScreen> createState() => _SampleAudioScreenState();
}

class _SampleAudioScreenState extends ConsumerState<SampleAudioScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('음성 등록 완료'),
        content: Text('음성 등록이 완료되었습니다.\n소중한 목소리를 들려주셔서 감사합니다.'),
        actions: [
          TextButton(
            onPressed: () {
              context.go('/');
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(voiceProvider);

    // 모든 녹음이 완료되면 다이얼로그 표시
    if (state.isAllCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCompletionDialog();
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: CustomAppBar(),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '문장 ${state.currentIndex + 1}/5',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  VoiceSamples.sentences[state.currentIndex],
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 40),
            if (state.error != null)
              Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: state.isRecording
                  ? ref.read(voiceProvider.notifier).stopRecording
                  : ref.read(voiceProvider.notifier).startRecording,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const CircleBorder(),
              ),
              child: Icon(
                state.isRecording ? Icons.stop : Icons.mic,
                size: 32,
              ),
            ),
            const SizedBox(height: 40),
            LinearProgressIndicator(
              value: state.completedIndices
                  .where((completed) => completed)
                  .length /
                  5,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AppBarClipper(),
      child: Container(
        color: Color(0xFFC9F5FF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                Image.asset('asset/logo.jpeg', scale: 10),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 40);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height - 60, size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
