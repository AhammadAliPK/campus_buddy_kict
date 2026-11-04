import 'package:flutter/material.dart';

class Course {
  final String code, name, day;
  final int creditHours;
  final IconData icon;
  final bool isFavorite;
  final bool enrolled;
  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon, {
    this.isFavorite = false,
    this.enrolled = false,
  });
  Course copyWith({bool? isFavorite, bool? enrolled}) => Course(
    code,
    name,
    creditHours,
    day,
    icon,
    isFavorite: isFavorite ?? this.isFavorite,
    enrolled: enrolled ?? this.enrolled,
  );
}
