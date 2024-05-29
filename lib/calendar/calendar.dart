import 'package:capstone_frontend/screen/statistic/model/schedule_resp_model.dart';
import 'package:capstone_frontend/const/api_utils.dart';
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
  final userId = UserManager().getUserId();

  Future<List<ScheduleRespModel>> respSchedule(String userId){
    return dio.get('$ip/get_future_api/getfuture/$userId').then((resp) {
      if(resp.statusCode != 200) return <ScheduleRespModel>[];
      return List<ScheduleRespModel>.from(resp.data.map((x) => ScheduleRespModel.fromJson(x)));
    });
  }

  void getSchedules() async {
    List<ScheduleRespModel> schedules = await respSchedule(userId!);

    if(mounted){
      setState(() {
        for (var i in schedules) {
          DateTime date = DateTime.parse(i.date);
          List<Event> existingEvents = [];
          existingEvents.add(Event(i.date,i.content));
          kEvents[date] = existingEvents;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSchedules();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
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
          )
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
                // String? imageUrl = dateImageUrls[day];
                BoxDecoration decoration;
                // 배경 있으면 배경 추가됨
                  decoration = BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('asset/logo.jpeg'),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle
                  );
                  return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: decoration,
                          alignment: Alignment.center,
                          child: Text(''),
                        );
                // return Column(
                //   children: [
                //     Container(
                //       margin: const EdgeInsets.symmetric(
                //         horizontal: 12.0,
                //         vertical: 4.0,
                //       ),
                //       decoration: decoration,
                //       alignment: Alignment.center,
                //       child: Text(''),
                //     ),
                //     Spacer(),
                //     Text('${day.day}', style: const TextStyle(
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black,
                //     )),
                //   ],
                // );
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
                        onTap: () {},
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