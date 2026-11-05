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

  Course copyWith({
    String? code, String? name, String? lecturer,
    String? day, String? time, int? creditHours,
    IconData? icon, bool? isFavorite, bool? enrolled,
    }) => Course(
      code: code ?? this.code,
      name: name ?? this.name,
      lecturer: lecturer ?? this.lecturer,
      day: day ?? this.day,
      time: time ?? this.time,
      creditHours: creditHours ?? this.creditHours,
      icon: icon ?? this.icon,
      isFavorite: isFavorite ?? this.isFavorite,
      enrolled: enrolled ?? this.enrolled,
    );
}


