import 'dart:convert';
import 'package:capstone_frontend/login_page.dart';
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

  late Stream<User?> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final User user = snapshot.data!;
            if (user != null) {
              return MainScreen();
            }
            return LoginPage();
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return LoginPage();
        },
      ),
    );
  }

  Stream<User?> _checkLoginStatus() async* {
    while (true) {
        final resp = await http.get(Uri.parse('http://3.34.199.26:5000/receive_user_info'));
        if (resp.statusCode == 200) {
          final user = User.fromJson(jsonDecode(resp.body));
          yield user;
        }
        else {
          yield null;
        }
        await Future.delayed(Duration(seconds: 5)); // 일정 시간마다 반복적으로 요청
    }
  }
}
