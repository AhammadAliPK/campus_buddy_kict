import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final String time; // ← NEW e.g. '09:00–10:30'
  final String venue; // ← NEW e.g. 'LT A'
  final IconData icon;
  final String? instructor; // ← NEW may be missing

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.time,
    this.venue,
    this.icon, [
    this.instructor,
  ]);
}
