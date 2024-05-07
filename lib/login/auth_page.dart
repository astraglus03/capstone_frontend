import 'dart:convert';
import 'package:capstone_frontend/const/ip.dart';
import 'package:capstone_frontend/login/login_page.dart';
import 'package:capstone_frontend/screen/main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: checkCurrentUser(UserManager().getUserId()), // userId를 바로 사용
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            // 사용자 데이터가 있으면 MainScreen으로 이동
            return MainScreen();
          } else {
            // 데이터가 없거나 로그인 필요 시 LoginPage로 이동
            return LoginPage();
          }
        },
      ),
    );
  }

  Future<User?> checkCurrentUser(String? userId) async {
    if (userId == null) return null; // userId가 null이면 로그인 페이지로 이동
    try {
      final response = await http.get(Uri.parse('$ip/userinfo/userinfo/$userId'));
      if (response.body.isNotEmpty) {
        var userData = jsonDecode(response.body);
        return User.fromJson(userData);
      }
    } catch (e) {
      print('Error checking current user: $e');
      return null;
    }
    return null;
  }
}
