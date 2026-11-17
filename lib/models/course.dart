import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final double creditHours;
  final String day;
  final String time;
  final String venue;
  final IconData icon;
  final String? instructor;

  final bool isFavorite;
  final bool enrolled;

  const Course({
    required this.code,
    required this.name,
    required this.creditHours,
    required this.day,
    required this.time,
    required this.venue,
    required this.icon,
    this.instructor,
    this.isFavorite = false,
    this.enrolled = false,
  });

  Course copyWith({
    String? code,
    String? name,
    double? creditHours,
    String? day,
    String? time,
    String? venue,
    IconData? icon,
    String? instructor,
    bool? isFavorite,
    bool? enrolled,
  }) {
    return Course(
      code: code ?? this.code,
      name: name ?? this.name,
      creditHours: creditHours ?? this.creditHours,
      day: day ?? this.day,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      icon: icon ?? this.icon,
      instructor: instructor ?? this.instructor,
      isFavorite: isFavorite ?? this.isFavorite,
      enrolled: enrolled ?? this.enrolled,
    );
  }
}