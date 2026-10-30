import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final List<String> days;
  final String time;
  final String venue;
  final IconData icon;
  final bool isFavourite;
  final bool enrolled;
  final String? instructor;
  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.days,
    this.time,
    this.venue,
    this.icon, {
    this.instructor, // FIX: back inside {} so it stays named + optional (data/courses.dart uses instructor:)
    this.isFavourite = false,
    this.enrolled = false,
  });
  // ← NEW method: make a copy with one difference
  // FIX: param renamed isFavorite -> isFavourite to match field + screen call
  Course copyWith({bool? isFavourite, bool? enrolled}) => Course(
    code,
    name,
    creditHours,
    days,
    time, // FIX: was missing, positional order must match constructor
    venue, // FIX: was missing
    icon,
    instructor: instructor, // FIX: keep instructor, else lost on every toggle
    isFavourite: isFavourite ?? this.isFavourite,
    enrolled: enrolled ?? this.enrolled,
  );
}
