import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final String time;
  final String venue;
  final IconData icon;
  final String? instructor;

  final bool isFavorite;
  final bool enrolled;

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

  Course copyWith({bool? isFavorite, bool? enrolled}) {
    return Course(
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
}
