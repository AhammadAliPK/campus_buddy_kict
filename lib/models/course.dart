import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final num creditHours;
  final String day;
  final IconData icon;
  final String time;
  final String venue;
  final String? instructor;
  final bool favorite;
  final bool enrolled;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon,
    this.time,
    this.venue, [
    this.instructor,
    this.favorite = false,
    this.enrolled = false,
  ]);

  Course copyWith({bool? favorite, bool? enrolled}) => Course(
    code,
    name,
    creditHours,
    day,
    icon,
    time,
    venue,
    instructor,
    favorite ?? this.favorite,
    enrolled ?? this.enrolled,
  );
}
