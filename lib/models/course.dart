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
  final bool isFavorite;
  final bool enrolled;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon, {
    this.time = '09:00 - 10:30',
    this.venue = 'KICT Lab',
    this.instructor,
    this.isFavorite = false,
    this.enrolled = false,
  });

  Course copyWith({bool? isFavorite, bool? enrolled}) => Course(
    code,
    name,
    creditHours,
    day,
    icon,
    time: time,
    venue: venue,
    instructor: instructor,
    isFavorite: isFavorite ?? this.isFavorite,
    enrolled: enrolled ?? this.enrolled,
  );
}
