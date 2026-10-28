import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final String lecturer;
  final String time;
  final String venue;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon, {
    this.lecturer = 'Not specified',
    this.time = 'Not specified',
    this.venue = 'Not specified',
  });
}
