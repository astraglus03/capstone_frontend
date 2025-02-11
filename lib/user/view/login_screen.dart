import 'package:capstone_frontend/user/component/logintextfield.dart';
import 'package:capstone_frontend/user/component/square_tile.dart';
import 'package:capstone_frontend/user/models/user_model.dart';
import 'package:capstone_frontend/user/view_models/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  static String get routeName => '/login';
  final idController = TextEditingController();
  final pwController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userMeProvider);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFC9F5FF),
        body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('asset/logo.jpeg', scale: 3),
                    if (state is UserModelError) 
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 30),
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
                    state is UserModelLoading
                        ? const Center(child: CircularProgressIndicator())
                        :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SquareTile(
                          imagePath: 'asset/naver.png',
                          onTap: () {},
                        ),
                        SquareTile(
                          imagePath: 'asset/kakao.png',
                          onTap: () {
                            ref.read(userMeProvider.notifier).loginWithKakao();
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