import 'package:capstone_frontend/calendar/calendar.dart';
import 'package:capstone_frontend/noti_service.dart';
import 'package:capstone_frontend/screen/home/home_screen.dart';
import 'package:capstone_frontend/provider/emotion_manager.dart';
import 'package:capstone_frontend/screen/statistic/statistic_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late bool isrecord;

  @override
  void initState(){
    isrecord = false;
    NotificationService().showNotification(
      title: '퐁당이',
      body: '5월 17일 ADsP시험 어떠셨나요?',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: Text('사용자 감정 맞춤 조절')),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('나는 친구때문에 화가 치밀어 올라', style: TextStyle(
                          decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('화난 목소리로\n읽어주세요!!!', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
                    SizedBox(height: 10),
                    if(isrecord)
                      Image.asset('asset/loading.gif'),
                    TextButton(
                      onPressed: (){
                        setState(() {
                          isrecord = !isrecord;
                        });
                      },
                      child: isrecord ? Text('녹음 중지') : Text('녹음 시작'),
                    ),
                  ],
                ),
              ),
            );
          }
      );
    });
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
