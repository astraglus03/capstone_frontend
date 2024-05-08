import 'package:capstone_frontend/const/api_utils.dart';
import 'package:flutter/material.dart';
import 'package:capstone_frontend/screen/main_screen.dart';
import 'package:capstone_frontend/login/login_page.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<double>? _scaleAnimation;
  bool isStopped = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    final userManager = UserManager();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 3.0).animate(
        CurvedAnimation(parent: _controller!, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller!, curve: Interval(0.5, 1.0, curve: Curves.easeOut)));

    _controller!.addListener(() {
      if (!isStopped && _controller!.value == 1.0 / 3.0) {
        setState(() {
          isStopped = true;
          _controller!.stop();
          _showOverlay(context);
        });
      }
    });

    userManager.userIdStream.listen((userId) {
      if (userId != null && userId.isNotEmpty) {
        _removeOverlay();
        _controller!.forward();
      }
    });

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        goToNewPage();
      }
    });
    _controller!.forward();
  }

  void _showOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: LoginPage(),
      ),
    );
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void goToNewPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller?.dispose();
    super.dispose();
  }
}
