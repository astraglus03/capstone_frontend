import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;
  final Color? emotionColor;

  const Event(this.title, this.emotionColor);

  @override
  String toString() => title;
}

/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

// api에 따른 수정 필요
final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}', null)))
  ..addAll({
    kToday: [
      Event('일정 나오는 곳. 일정1',null),
      Event('일정 나오는 곳. 일정2',null),
    ],
  });

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