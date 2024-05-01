import 'package:capstone_frontend/screen/chatbot/chatbot_screen.dart';
import 'package:capstone_frontend/screen/home/home_screen.dart';
import 'package:capstone_frontend/screen/statistic/statistic_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _MainWidgets = <Widget>[
    const HomeScreen(),
    const ChatbotScreen(),
    const StatisticScreen(),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('asset/conversation.png')),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '',
          ),
        ],
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: _MainWidgets.elementAt(_index),
    );
  }
}
