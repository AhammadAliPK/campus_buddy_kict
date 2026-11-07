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

  Course copyWith({
    String? name,
    int? creditHours,
    String? day,
    IconData? icon,
    String? time,
    String? venue,
    String? instructor,
    bool? isFavorite,
    bool? enrolled,
  }) => Course(
    code,
    name ?? this.name,
    creditHours ?? this.creditHours,
    day ?? this.day,
    icon ?? this.icon,
    time: time ?? this.time,
    venue: venue ?? this.venue,
    instructor: instructor ?? this.instructor,
    isFavorite: isFavorite ?? this.isFavorite,
    enrolled: enrolled ?? this.enrolled,
  );
}
