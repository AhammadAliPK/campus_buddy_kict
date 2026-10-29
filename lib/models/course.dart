
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

  // Week 5: Favorite and enrollment status
  final bool isFavorite;
  final bool enrolled;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon, {
    this.lecturer = 'Not specified',
    this.time = 'Not specified',
    this.venue = 'Not specified',
    this.isFavorite = false,
    this.enrolled = false,
  });

  // Create an updated copy without changing the other course details
  Course copyWith({
    bool? isFavorite,
    bool? enrolled,
  }) {
    return Course(
      code,
      name,
      creditHours,
      day,
      icon,
      lecturer: lecturer,
      time: time,
      venue: venue,
      isFavorite: isFavorite ?? this.isFavorite,
      enrolled: enrolled ?? this.enrolled,
    );
  }
}
