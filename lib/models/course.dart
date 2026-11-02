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
  final bool isFavorite;   // NEW (Step 2)
  final bool enrolled;     // NEW (Step 2)

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon,
    this.time,
    this.venue, {
    this.instructor,
    this.isFavorite = false,   // NEW (Step 2)
    this.enrolled = false,     // NEW (Step 2)
  });

  // NEW (Step 2): make a copy with one difference
  Course copyWith({bool? isFavorite, bool? enrolled}) => Course(
        code,
        name,
        creditHours,
        day,
        icon,
        time,
        venue,
        instructor: instructor,
        isFavorite: isFavorite ?? this.isFavorite,
        enrolled: enrolled ?? this.enrolled,
      );
}