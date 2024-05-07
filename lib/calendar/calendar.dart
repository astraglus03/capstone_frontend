import 'dart:convert';
import 'package:capstone_frontend/const/ip.dart';
import 'package:capstone_frontend/screen/diary_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utils.dart';

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

  Map<DateTime, String> dateImageUrls = {
    DateTime(2024, 5, 14): 'asset/img.webp',
    DateTime(2024, 5, 25): 'asset/view 3.webp',
  };
  Map<DateTime, String> emotionColors = {};

  @override
  void initState() {
    super.initState();
    // fetchDatas();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void fetchDatas() async {
    final resp = await dio.post('$ip/image');
    var data = jsonDecode(resp.data);

    setState(() {
      data.forEach((item) {
        DateTime date = DateTime.parse(item['date']);
        String imageUrl = item['imageUrl'];
        dateImageUrls[date] = imageUrl;
        String emotionUrl = item['emotionColor'];
      });
    });
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
        title: Text('나의 캘린더 일정'),
        centerTitle: true,
      ),
      body: Column(
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
              leftChevronIcon: Icon(Icons.arrow_back_ios, size: 15), // 좌측 화살표 아이콘
              rightChevronIcon: Icon(Icons.arrow_forward_ios, size: 15), // 우측 화살표 아이콘
            ),
            onHeaderTapped: (date) {
              _showYearMonthPicker(context);
            },
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
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                String? imageUrl = dateImageUrls[day];
                BoxDecoration decoration;
                // 배경 있으면 배경 추가됨
                if (imageUrl != null) {
                  decoration = BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,
                  );
                } else {
                  decoration = BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('asset/img.webp'),
                      fit: BoxFit.cover,
                    ),
                    // color: Colors.lightBlue.shade50, // 배경 처리 예정
                    shape: BoxShape.circle,
                  );
                }
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: decoration,
                  alignment: Alignment.center,
                  child: Text('${day.day}', style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
                );
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
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
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => DiaryDetailScreen())
                          );
                        },
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
