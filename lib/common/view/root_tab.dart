import 'package:capstone_frontend/calendar/view/calendar.dart';
import 'package:capstone_frontend/home/emotion_manager.dart';
import 'package:capstone_frontend/home/home_screen.dart';
import 'package:capstone_frontend/statistic/view/statistic_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> {

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
    Calendar(),
    StatisticScreen(),
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
