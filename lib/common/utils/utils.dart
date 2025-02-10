import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Event {
  final String date;
  final String title;

  const Event(this.date,this.title);

  @override
  String toString() {
    final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date); // 날짜 문자열을 DateTime 객체로 파싱
    final String formattedDate = DateFormat('dd').format(parsedDate) + '일'; // 원하는 형식 'dd일'로 포맷
    return formattedDate + ' - ' + title; // 최종 문자열 생성
  }
}

/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}


final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 240, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 12, kToday.day);

void showYearMonthPicker({
  required BuildContext context,
  required DateTime initialDate,
  required ValueChanged<DateTime> onDateChanged,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Container(
          width: 300,
          height: 300,
          child: SfDateRangePicker(
            view: DateRangePickerView.year,
            selectionMode: DateRangePickerSelectionMode.single,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              if (args.value is DateTime) {
                Navigator.pop(context);
                onDateChanged(args.value);
              }
            },
            maxDate: kLastDay,
            minDate: kFirstDay,
            initialDisplayDate: initialDate,
            showNavigationArrow: true,
            allowViewNavigation: true,
          ),
        ),
      );
    },
  );
}