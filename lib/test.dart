import 'package:capstone_frontend/login/kakao_login.dart';
import 'package:capstone_frontend/login/main_view_model.dart';
import 'package:flutter/material.dart';

class SocialLogin extends StatefulWidget {
  const SocialLogin({super.key});

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${viewModel.isLogined}'),
        ElevatedButton(
          onPressed: () async {
            await viewModel.login();
            setState(() {});
          },
          child: const Text('카카오 로그인'),
        ),
      ],
    );
  }
}
