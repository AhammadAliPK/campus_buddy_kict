import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final String lecturer;
  final String day;
  final String time;
  final int creditHours;
  final IconData icon;
  final bool isFavorite;
  final bool enrolled;

  const Course({
    required this.code,
    required this.name,
    required this.lecturer,
    required this.day,
    required this.time,
    this.creditHours = 3,
    this.icon = Icons.book,
    this.isFavorite = false,
    this.enrolled = false,
  });

  Course copyWith({bool? isFavorite, bool? enrolled}) => Course(
        code: code,
        name: name,
        lecturer: lecturer,
        day: day,
        time: time,
        creditHours: creditHours,
        icon: icon,
        isFavorite: isFavorite ?? this.isFavorite,
        enrolled: enrolled ?? this.enrolled,
      );
}


