import 'package:capstone_frontend/login/kakao_login.dart';
import 'package:capstone_frontend/login/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:capstone_frontend/login/logintextfield.dart';
import 'package:capstone_frontend/login/square_tile.dart';

class LoginPage extends StatelessWidget {
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('asset/logo.jpeg', scale: 3),
              SizedBox(height: 30),
              LoginTextField(
                controller: idController,
                hintText: '아이디를 입력하세요.',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              LoginTextField(
                controller: pwController,
                hintText: '비밀번호를 입력하세요.',
                obscureText: true,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SquareTile(
                    imagePath: 'asset/naver.png',
                    onTap: () {},
                  ),
                  SquareTile(
                    imagePath: 'asset/kakao.png',
                    onTap: () async {
                      await viewModel.login();
                    },
                  ),
                  SquareTile(
                    imagePath: 'asset/github.png',
                    onTap: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}