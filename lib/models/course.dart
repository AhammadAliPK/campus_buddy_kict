import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;

  // Restored properties
  final String time;
  final String? instructor;
  final String venue;

  final bool isFavorite;
  final bool enrolled;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon,
    this.time,
    this.instructor,
    this.venue, {
    this.isFavorite = false,
    this.enrolled = false,
  });

  Course copyWith({
    bool? isFavorite,
    bool? enrolled,
  }) =>
      Course(
        code,
        name,
        creditHours,
        day,
        icon,
        time,
        instructor,
        venue,
        isFavorite: isFavorite ?? this.isFavorite,
        enrolled: enrolled ?? this.enrolled,
      );
}