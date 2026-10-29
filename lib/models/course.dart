import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final String time;
  final String venue;
  final String? instructor;
  final bool isEnrolled;
  final bool isFavorite;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon,
    this.time,
    this.venue, [
    this.instructor,
    this.isEnrolled = false,
    this.isFavorite = false,
  ]);

  Course copyWith({
    bool? isEnrolled,
    bool? isFavorite,
  }) {
    return Course(
      code,
      name,
      creditHours,
      day,
      icon,
      time,
      venue,
      instructor,
      isEnrolled ?? this.isEnrolled,
      isFavorite ?? this.isFavorite,
    );
  }
}