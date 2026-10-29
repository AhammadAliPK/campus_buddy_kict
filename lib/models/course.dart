import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final String time;
  final String venue;
  final String? instructor;
  final bool isFavorite; // true when the user stars this course
  final bool enrolled; // true when the user enrolls in it

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon,
    this.time,
    this.venue, [
    this.instructor,
    this.isFavorite = false,
    this.enrolled = false,
  ]);

  // A copy with at most one difference
  Course copyWith({bool? isFavorite, bool? enrolled}) => Course(
        code,
        name,
        creditHours,
        day,
        icon,
        time,
        venue,
        instructor,
        isFavorite ?? this.isFavorite,
        enrolled ?? this.enrolled,
      );
}