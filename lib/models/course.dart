import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final double creditHours; // double because some courses are 0.5 CH
  final String day;
  final String time;
  final String venue;
  final String? instructor; // null = not known yet
  final IconData icon;
  final bool isFavorite; // true when the user stars this course
  final bool enrolled; // true when the user enrolls in it

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.time,
    this.venue,
    this.icon, {
    this.instructor,
    this.isFavorite = false,
    this.enrolled = false,
  });

  // Make a copy with one difference (fields are final, so we copy)
  Course copyWith({bool? isFavorite, bool? enrolled}) => Course(
        code,
        name,
        creditHours,
        day,
        time,
        venue,
        icon,
        instructor: instructor,
        isFavorite: isFavorite ?? this.isFavorite,
        enrolled: enrolled ?? this.enrolled,
      );

  // 3.0 -> "3", 0.5 -> "0.5"
  String get chText =>
      creditHours % 1 == 0 ? creditHours.toInt().toString() : creditHours.toString();
}
