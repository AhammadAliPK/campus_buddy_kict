import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final double creditHours; // double: Cooking Skills is 0.5 CH
  final String day;
  final String time;
  final String venue;
  final IconData icon;
  final String? instructor; // may be missing
  final bool starred;
  final bool enrolled;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.time,
    this.venue,
    this.icon, {
    this.instructor,
    this.starred = false,
    this.enrolled = false,
  });

  // Fields are final, so a "change" is a copy with some differences.
  Course copyWith({
    String? name,
    double? creditHours,
    String? day,
    String? time,
    String? venue,
    bool? starred,
    bool? enrolled,
  }) =>
      Course(
        code,
        name ?? this.name,
        creditHours ?? this.creditHours,
        day ?? this.day,
        time ?? this.time,
        venue ?? this.venue,
        icon,
        instructor: instructor,
        starred: starred ?? this.starred,
        enrolled: enrolled ?? this.enrolled,
      );
}
