import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final String lecturer;
  final String day;
  final String time;
  final int creditHours;
  final IconData icon;

  const Course({
    required this.code,
    required this.name,
    required this.lecturer,
    required this.day,
    required this.time,
    this.creditHours = 3,
    this.icon = Icons.book,
  });
}


