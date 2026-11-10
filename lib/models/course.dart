import 'package:flutter/material.dart';

/// The weekdays a class can meet on — used by the day chips and the forms.
const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

class Course {
  final String code;
  final String name;
  final double creditHours; // double, because some courses are 0.5 CH
  final List<String> days; // a list, because some classes meet Tue AND Thu
  final IconData icon;
  final String time; // Week 4 homework 1, e.g. '09:00–10:30'
  final String venue; // Week 4 homework 1, e.g. 'LT A'
  final String? instructor; // Week 4 homework 2: the ? means "may be missing"
  final bool isFavorite; // true when the user stars this course
  final bool enrolled; // true when the user enrolls in it

  // time and venue must always be given; instructor may be left out
  const Course(this.code, this.name, this.creditHours, this.days, this.icon,
      {required this.time,
      required this.venue,
      this.instructor,
      this.isFavorite = false,
      this.enrolled = false});

  // ['Tuesday', 'Thursday'] -> 'Tue/Thu', used in the row subtitle
  String get shortDays => days.map((d) => d.substring(0, 3)).join('/');

  // make a copy with one difference
  Course copyWith({
    String? code,
    String? name,
    double? creditHours,
    List<String>? days,
    IconData? icon,
    String? time,
    String? venue,
    String? instructor,
    bool? isFavorite,
    bool? enrolled,
  }) => Course(
    code ?? this.code,
    name ?? this.name,
    creditHours ?? this.creditHours,
    days ?? this.days,
    icon ?? this.icon,
    time: time ?? this.time,
    venue: venue ?? this.venue,
    instructor: instructor ?? this.instructor,
    isFavorite: isFavorite ?? this.isFavorite,
    enrolled: enrolled ?? this.enrolled,
  );
}

/// 3.0 -> '3', 0.5 -> '0.5', 13.5 -> '13.5'
String formatCh(double ch) =>
    ch == ch.roundToDouble() ? ch.toInt().toString() : ch.toString();

// Week 4 homework 3 (optional): day names -> numbers, for sorting by day
const Map<String, int> dayOrder = {
  'Monday': 1,
  'Tuesday': 2,
  'Wednesday': 3,
  'Thursday': 4,
  'Friday': 5,
  'Saturday': 6,
  'Sunday': 7,
};

// returns a new list sorted by (first) day, then by start time
List<Course> sortedByDay(List<Course> list) {
  int firstDay(Course c) =>
      c.days.isEmpty ? 99 : (dayOrder[c.days.first] ?? 99);
  final copy = List.of(list);
  copy.sort((a, b) {
    final byDay = firstDay(a).compareTo(firstDay(b));
    if (byDay != 0) return byDay;
    return a.time.compareTo(b.time);
  });
  return copy;
}
