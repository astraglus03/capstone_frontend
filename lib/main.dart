import 'package:capstone_frontend/help1.dart';
import 'package:capstone_frontend/login/auth_page.dart';
import 'package:capstone_frontend/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: '1cf48672c2673ece9d56f59a5485150f');
  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(
    // themeMode: ThemeMode.system,
    // theme: ThemeData(
    //   brightness: Brightness.light,
    // ),
    // darkTheme: ThemeData(
    //   brightness: Brightness.dark,
    // ),
    theme: ThemeData(
      brightness: Brightness.light,
    ),
    debugShowCheckedModeBanner: false,
    home: AuthPage(),
  ));
}
