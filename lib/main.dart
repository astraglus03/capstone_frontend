import 'package:capstone_frontend/common/const/api_keys.dart';
import 'package:capstone_frontend/common/view_models/go_router.dart';
import 'package:capstone_frontend/register/view/sample_audio.dart';
import 'package:capstone_frontend/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {

  // 카카오 SDK 초기화
  KakaoSdk.init(nativeAppKey: ApiKeys.kakaoNativeAppKey,);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'KCC-Ganpan',
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: LoginScreen(),
    // );
  }


}
