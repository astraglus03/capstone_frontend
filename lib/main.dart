import 'package:capstone_frontend/login/auth_page.dart';
import 'package:capstone_frontend/noti_service.dart';
import 'package:capstone_frontend/provider/provider_observer.dart';
import 'package:capstone_frontend/sample_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(Duration(seconds: 1));
  FlutterNativeSplash.remove();
  NotificationService().initNotification();
  KakaoSdk.init(nativeAppKey: '1cf48672c2673ece9d56f59a5485150f');
  runApp(
    ProviderScope(
      observers: [
         Logger(),
      ],
        child: MaterialApp(
    // themeMode: ThemeMode.system,
    // theme: ThemeData(
    //   brightness: Brightness.light,
    // ),
    // darkTheme: ThemeData(
    //   brightness: Brightness.dark,
    // ),
    theme: ThemeData(
      fontFamily: 'KCC-Ganpan',
      brightness: Brightness.light,
    ),
    debugShowCheckedModeBanner: false,
    home: AuthPage(),
  )),
  );
}
