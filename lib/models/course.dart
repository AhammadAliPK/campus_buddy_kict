import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final String time; // Week 4 homework 1, e.g. '09:00–10:30'
  final String venue; // Week 4 homework 1, e.g. 'LT A'
  final String? instructor; // Week 4 homework 2: the ? means "may be missing"
  final bool isFavorite; // true when the user stars this course
  final bool enrolled; // true when the user enrolls in it

  // time and venue must always be given; instructor may be left out
  const Course(this.code, this.name, this.creditHours, this.day, this.icon,
      {required this.time,
      required this.venue,
      this.instructor,
      this.isFavorite = false,
      this.enrolled = false});

  // 'Monday' -> 'Mon', used in the row subtitle
  String get shortDay => day.substring(0, 3);

  // make a copy with one difference
  Course copyWith({
    String? code,
    String? name,
    int? creditHours,
    String? day,
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
    day ?? this.day,
    icon ?? this.icon,
    time: time ?? this.time,
    venue: venue ?? this.venue,
    instructor: instructor ?? this.instructor,
    isFavorite: isFavorite ?? this.isFavorite,
    enrolled: enrolled ?? this.enrolled,
  );
}

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

// returns a new list sorted by day, then by start time
List<Course> sortedByDay(List<Course> list) {
  final copy = List.of(list);
  copy.sort((a, b) {
    final byDay = (dayOrder[a.day] ?? 99).compareTo(dayOrder[b.day] ?? 99);
    if (byDay != 0) return byDay;
    return a.time.compareTo(b.time);
  });
  return copy;
}
