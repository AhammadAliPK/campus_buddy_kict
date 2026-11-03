import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final String time; // e.g. '09:00–10:30'
  final String venue; // e.g. 'LT A'
  final IconData icon;
  final String? instructor; // may be missing
  final bool isFavorite; // ← NEW: true when the user stars this course
  final bool enrolled; // ← NEW: true when the user enrolls in it

  // ← CHANGED: optional extras in {curly braces}
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

  // ← NEW method: make a copy with one difference
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
