import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final String time;
  final String venue;
  final IconData icon;
  final String? instructor; // may be missing
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

  // A Course can't change, so "change" it = make a copy with one difference
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
}
