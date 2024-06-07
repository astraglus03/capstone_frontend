import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:capstone_frontend/screen/statistic/model/diary_model.dart';
import 'package:capstone_frontend/screen/statistic/model/month_emotion_resp_model.dart';
import 'package:capstone_frontend/screen/statistic/model/schedule_resp_model.dart';
import 'package:capstone_frontend/const/api_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final dio = Dio();
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final userId = UserManager().getUserId();
  late Future<List<DiaryModel>> changeEmotion;
  String feedback ='';
  Future<List<ScheduleRespModel>> respSchedule(String userId) {
    return dio.get('$ip/get_future_api/getfuture/$userId').then((resp) {
      if (resp.statusCode != 200) return <ScheduleRespModel>[];
      return List<ScheduleRespModel>.from(
          resp.data.map((x) => ScheduleRespModel.fromJson(x)));
    });
  }

  Future<List<DiaryModel>> respEmotions(String userId) async {
    final resp = await dio.post('$ip/Search_Diary_api/searchdiary', data: {
      'userId': userId,
      'date': 'None',
      'month': 'None',
      'limit': 'None',
    });

    if (resp.statusCode == 200) {
      return List<DiaryModel>.from(
          resp.data.map((x) => DiaryModel.fromJson(x)));
    }
    return <DiaryModel>[];
  }

  Future<List<DiaryMonthModel>> sendDiaryToBackend(
      String userId, String month) async {
    try {
      final resp = await dio.post('$ip/Count_Month_Emotion/countmonthemotion', data: {
        'userId': userId,
        'month': month,
      });
      print(resp.data);

      if (resp.statusCode == 200 && resp.data != '해당 날에 대한 감정 정보가 없습니다.') {
        Map<String, dynamic> jsonData = resp.data;
        // print([MonthEmotionRespModel.fromJson(jsonData)]);
        return [DiaryMonthModel.fromJson(jsonData)]; // 단일 객체를 리스트로 변환
      } else {
        print('Failed to load data with status code: ${resp.statusCode}');
        return <DiaryMonthModel>[];
      }
    } catch (e) {
      print('An exception occurred: $e');
      throw Exception('Failed to communicate with server');
    }
  }

  void getSchedules() async {
    List<ScheduleRespModel> schedules = await respSchedule(userId!);
    setState(() {
      for (var i in schedules) {
        DateTime date = DateTime.parse(i.date);

        if (kEvents.containsKey(date)) {
          List<Event> existingEvents = kEvents[date]!;
          bool isDuplicate = existingEvents.any((e) => e.title == i.content);

          if (!isDuplicate) {
            existingEvents.add(Event(i.date, i.content));
          }
        } else {
          kEvents[date] = [Event(i.date, i.content)];
        }
      }
    });
  }

  void getMonthFeedback() async {
    List<DiaryMonthModel> dm = await sendDiaryToBackend(userId!, DateFormat('yyyy-MM').format(_focusedDay));
    setState(() {
      if (dm[0].monthFeedback != feedback) {
        feedback = dm[0].monthFeedback;
        print('지금 변경됨');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getSchedules();
    changeEmotion = respEmotions(userId!);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    getMonthFeedback();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _showYearMonthPicker(BuildContext context) {
    showYearMonthPicker(
      context: context,
      initialDate: _focusedDay,
      onDateChanged: (DateTime selectedDate) {
        setState(() {
          _focusedDay = selectedDate;
          _selectedDay = _focusedDay;
          _selectedEvents.value = _getEventsForDay(_selectedDay!);
        });
      },
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, // 뒤로가기 없애기
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
            ],
          )),
      body: FutureBuilder<List<DiaryModel>>(
          future: changeEmotion,
          builder: (context, AsyncSnapshot<List<DiaryModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('로딩 중...'),
                  SizedBox(height: 10),
                  CircularProgressIndicator(),
                ],
              ));
            }
            if (snapshot.hasError) {
              return const Center(child: Text('에러가 발생했습니다.'));
            }
            final data = snapshot.data!;
            return Column(
              children: [
                TableCalendar<Event>(
                  locale: 'ko_KR',
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    // 여기서 캘린더 커스터마이징 가능
                    outsideDaysVisible: true,
                    holidayTextStyle: TextStyle(color: Colors.red),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false, // 필요하지 않다면 포맷 버튼 숨기기
                    titleCentered: true, // 타이틀을 중앙에 위치
                    titleTextStyle: TextStyle(fontSize: 16.0), // 타이틀 텍스트 스타일 지정
                  ),
                  onHeaderTapped: (date) {
                    _showYearMonthPicker(context);
                  },
                  availableGestures: AvailableGestures.all,
                  // pageJumpingEnabled: true,
                  onDaySelected: _onDaySelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                    getMonthFeedback();
                  },
                  rowHeight: 70,
                  // daysOfWeekHeight: 30,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isNotEmpty) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          width: 10.0,
                          height: 10.0,
                          child: SizedBox.shrink(),
                        );
                      }
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      String getEmotionRoute(String emotion) {
                        switch (emotion) {
                          case "중립":
                            return 'asset/emotion/neutral.png';
                          case "슬픔":
                            return 'asset/emotion/sad.png';
                          case "분노":
                            return 'asset/emotion/angry.png';
                          case "행복":
                            return 'asset/emotion/happy.png';
                          case "당황":
                            return 'asset/emotion/embarrassed.png';
                          case "상처":
                            return 'asset/emotion/hurt.png';
                          case "불안":
                            return 'asset/emotion/anxious.png';
                          default:
                            return '';
                        }
                      }

                      String? imageUrl;
                      for (var i in data) {
                        if (DateFormat('yyyy-MM-dd').format(i.date!) ==
                            DateFormat('yyyy-MM-dd').format(day)) {
                          imageUrl = getEmotionRoute(i.changeEmotion![0]);
                          break;
                        }
                      }

                      BoxDecoration decoration;
                      if (imageUrl != null) {
                        decoration = BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imageUrl),
                            fit: BoxFit.contain,
                          ),
                          shape: BoxShape.rectangle,
                        );
                        return Container(
                          // margin: const EdgeInsets.symmetric(
                          //   horizontal: 12.0,
                          //   vertical: 4.0,
                          // ),
                          decoration: decoration,
                          alignment: Alignment.center,
                          child: Text(''),
                        );
                      } else {
                        decoration = BoxDecoration(shape: BoxShape.circle);
                        return Container(
                          decoration: decoration,
                          alignment: Alignment.center,
                          child: Text('${day.day}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ListTile(
                                    onTap: () {},
                                    title: Text('${value[index]}'),
                                  ),
                                );
                              },
                              childCount: value.length,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                onTap: () {},
                                title: Text(feedback),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
