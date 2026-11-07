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

  // A Course can't change, so "change" it = make a copy with differences.
  // Week 6 homework: the edit screen needs every field, not just the two flags.
  Course copyWith({
    String? code,
    String? name,
    int? creditHours,
    String? day,
    String? time,
    String? venue,
    String? instructor,
    bool? isFavorite,
    bool? enrolled,
  }) =>
      Course(
        code ?? this.code,
        name ?? this.name,
        creditHours ?? this.creditHours,
        day ?? this.day,
        time ?? this.time,
        venue ?? this.venue,
        icon,
        instructor: instructor ?? this.instructor,
        isFavorite: isFavorite ?? this.isFavorite,
        enrolled: enrolled ?? this.enrolled,
      );
}
