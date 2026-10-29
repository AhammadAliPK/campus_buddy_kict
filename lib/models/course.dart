import 'package:flutter/material.dart';

class Course {
  final String? code;
  final String? name;
  final double creditHours;
  final String day;
  final IconData icon;
  final String time;
  final String? instructor;
  final String venue;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon,
    this.time, { // ADD: Sixth positional argument.
    required this.venue, // ADD: Named argument.
    this.instructor, // ADD: Optional named argument.
  });
}
