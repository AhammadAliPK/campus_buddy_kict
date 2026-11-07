import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final bool isFavorite; // ← NEW: true when the user stars this course
  final bool enrolled; // ← NEW: true when the user enrolls in it

  // CHANGED: constructor now takes two optional extras in {curly braces}
  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon, {
    this.isFavorite = false,
    this.enrolled = false,
  });

  // NEW method: make a copy with one difference
  Course copyWith({
    bool? isFavorite,
    bool? enrolled,
    String? name,
    int? creditHours,
    String? day,
    IconData? icon,
  }) => Course(
    code,
    name ?? this.name,
    creditHours ?? this.creditHours,
    day ?? this.day,
    icon ?? this.icon,
    isFavorite: isFavorite ?? this.isFavorite,
    enrolled: enrolled ?? this.enrolled,
  );
}
