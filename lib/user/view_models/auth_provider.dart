import 'package:capstone_frontend/common/view/root_tab.dart';
import 'package:capstone_frontend/common/view/splash_screen.dart';
import 'package:capstone_frontend/home/view/diary_detail_screen.dart';
import 'package:capstone_frontend/register/models/voice_model.dart';
import 'package:capstone_frontend/register/view/sample_audio_screen.dart';
import 'package:capstone_frontend/register/view_models/voice_provider.dart';
import 'package:capstone_frontend/user/models/user_model.dart';
import 'package:capstone_frontend/user/view/login_screen.dart';
import 'package:capstone_frontend/user/view_models/user_me_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => LoginScreen(),
    ),
    GoRoute(
      path: '/voice',
      name: SampleAudioScreen.routeName,
      builder: (_, state) => SampleAudioScreen(),
    ),
    GoRoute(
      path: '/',
      name: RootTab.routeName,
      builder: (context, state) => RootTab(),
      routes: [
        GoRoute(
          path: 'diaryDetail/:did',
          name: DiaryDetailScreen.routeName,
          builder: (_, state) => DiaryDetailScreen(id: state.pathParameters['did']!),
        ),
      ],
    ),
    // GoRoute(
    //   path: '/map',
    //   name: MapScreen.routeName,
    //   builder: (_, state) => MapScreen(),
    // ),
    // GoRoute(
    //   path: '/chatbot',
    //   name: ChatbotScreen.routeName,
    //   builder: (_, state) => ChatbotScreen(),
    // ),
    // GoRoute(
    //   path: '/social',
    //   name: SocialScreen.routeName,
    //   builder: (_, state) => SocialScreen(),
    // ),

  ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final voice = ref.read(voiceProvider);

    final logginIn = state.matchedLocation == '/login';
    final isSampleAudio = state.matchedLocation == '/voice';

    // 유저 정보가 없는데 로그인중이면 그대로 아니면 로그인페이지로
    if (user == null) {
      return logginIn ? null : '/login';
    }

    //user가 Null이 아님
    // 1) UserModel인 상태
    if (user is UserModel) {
      // 로그인 페이지나 스플래시 화면에 있을 때
      if (logginIn || state.matchedLocation == '/splash') {
        // 음성 등록이 완료되지 않았다면 음성 등록 화면으로
        if (!voice.isAllCompleted && !isSampleAudio) {
          return '/voice';
        }
        // 음성 등록이 완료되었다면 홈으로
        return '/';
      }
      return null;
    }

    // 2) UserModel Error
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}