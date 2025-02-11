import 'package:capstone_frontend/common/view/root_tab.dart';
import 'package:capstone_frontend/common/view/splash_screen.dart';
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
      path: '/',
      name: RootTab.routeName,
      builder: (context, state) => RootTab(),
      routes: [
        // GoRoute(
        //   path: 'terms',
        //   name: TermsScreen.routeName,
        //   builder: (_, state) => TermsScreen(),
        // ),
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

    final logginIn = state.matchedLocation == '/login';

    // 유저 정보가 없는데 로그인중이면 그대로 아니면 로그인페이지로
    if (user == null) {
      return logginIn ? null : '/login';
    }

    //user가 Null이 아님
    // 1) UserModel인 상태
    // 로그인중이거나 현재 위치가 splashscreen이면 홈으로 이동
    if (user is UserModel) {
      return logginIn || state.matchedLocation == '/splash' ? '/' : null;
    }

    // 2) UserModel Error
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null;
  }
}