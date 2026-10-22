import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final List<String> days;
  final String time;
  final String venue;
  final IconData icon;
  final String? instructor;
  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.days,
    this.time,
    this.venue,
    this.icon, {
    this.instructor,
  });
}
