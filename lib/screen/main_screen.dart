import 'package:capstone_frontend/calendar/calendar.dart';
import 'package:capstone_frontend/screen/home/home_screen.dart';
import 'package:capstone_frontend/provider/emotion_manager.dart';
import 'package:capstone_frontend/screen/statistic/statistic_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState(){
    // setPermissions();

    // NotificationService().showNotification(
    //   title: '퐁당이',
    //   body: '5월 17일 ADsP시험 어떠셨나요?',
    // );
    super.initState();
  }

  final List<Widget> _MainWidgets = <Widget>[
    HomeScreen(),
    const Calendar(),
    ChangeNotifierProvider(create: (context) => EmotionManager(), child: StatisticScreen()),
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
            icon: Icon(Icons.calendar_today_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '',
          ),
        ],
        currentIndex: _index,
        selectedIconTheme: IconThemeData(color: Colors.blue),
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
