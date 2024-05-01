import 'package:capstone_frontend/login/kakao_login.dart';
import 'package:capstone_frontend/login/logintextfield.dart';
import 'package:capstone_frontend/login/main_view_model.dart';
import 'package:capstone_frontend/login/square_tile.dart';
import 'package:capstone_frontend/screen/main_screen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final viewModel = MainViewModel(KakaoLogin());
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  Animation<double>? _opacityAnimation;
  bool isStopped = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 3.0).animate(
        CurvedAnimation(
            parent: _controller!,
            curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _controller!,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut)));

    _controller!.addListener(() {
      if (!viewModel.isLogined && _controller!.value == 1.0 / 3.0) {
        setState(() {
          isStopped = true;
        });
        _controller!.stop();
      }
    });

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        goToNewPage(context);
      }
    });
    _controller!.forward();
  }

  void goToNewPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLogined) {
      _controller!.forward(from:_controller!.value);
    }
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: _controller!,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation!.value,
                  child: Transform.scale(
                    scale: _scaleAnimation!.value,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('asset/img.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (!viewModel.isLogined && isStopped == true) loginAnimation(),
          ],
        ),
      ),
    );
  }

  Center loginAnimation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('asset/logo.webp', scale: 5),
          LoginTextField(
            controller: idController,
            hintText: '아이디를 입력하세요.',
            obscureText: false,
          ),
          const SizedBox(height: 30),
          LoginTextField(
            controller: pwController,
            hintText: '비밀번호를 입력하세요.',
            obscureText: true,
          ),
          const SizedBox(height: 60),
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
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
