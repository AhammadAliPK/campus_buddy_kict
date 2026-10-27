import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final String time; // like '09:00-10:30'
  final String venue; // like 'LT A'
  final IconData icon;
  final String? instructor; // null = not known yet

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.time,
    this.venue,
    this.icon, {
    this.instructor,
  });
}
