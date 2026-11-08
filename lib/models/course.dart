import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final String time; // like '09:00-10:30'
  final String venue; // like 'LT A'
  final IconData icon;
  final String? instructor; // null = not known yet
  final bool isFavorite;   // ← NEW: true when the user stars this course
  final bool enrolled;     // ← NEW: true when the user enrolls in it

  // ← CHANGED: constructor now takes two optional extras in {curly braces}
  const Course(this.code, this.name, this.creditHours, this.day, this.time, this.venue, this.icon,
      {this.instructor, this.isFavorite = false, this.enrolled = false});

  // ← NEW method: make a copy with one difference
  Course copyWith({String? name, int? creditHours, bool? isFavorite, bool? enrolled}) => Course(   // ← CHANGED
    code, name ?? this.name, creditHours ?? this.creditHours, day, time, venue, icon,         // ← CHANGED
    instructor: instructor,
    isFavorite: isFavorite ?? this.isFavorite,
    enrolled: enrolled ?? this.enrolled,
  );
}
