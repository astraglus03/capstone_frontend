import 'package:capstone_frontend/login/view/auth_page.dart';
import 'package:capstone_frontend/login/view/login_page.dart';
import 'package:capstone_frontend/register/view/sample_audio.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // NotificationService().initNotification();
  KakaoSdk.init(nativeAppKey: '1cf48672c2673ece9d56f59a5485150f');
  runApp(
    ProviderScope(child: MaterialApp(
    theme: ThemeData(
      fontFamily: 'KCC-Ganpan',
      brightness: Brightness.light,
    ),
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  )),
  );
}
