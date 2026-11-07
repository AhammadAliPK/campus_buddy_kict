
import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;

  // Week 4 Assignment 3
  final String time;
  final String venue;
  final String? instructor;

  // Week 5 Lab
  final bool isFavorite;
  final bool enrolled;

  const Course({
    required this.code,
    required this.name,
    required this.creditHours,
    required this.day,
    required this.icon,
    required this.time,
    required this.venue,
    this.instructor,
    this.isFavorite = false,
    this.enrolled = false,
  });

  
  Course copyWith({
    String? code,
    String? name,
    int? creditHours,
    String? day,
    IconData? icon,
    String? time,
    String? venue,
    String? instructor,
    bool? isFavorite,
    bool? enrolled,
  }) {
    return Course(
      code: code ?? this.code,
      name: name ?? this.name,
      creditHours: creditHours ?? this.creditHours,
      day: day ?? this.day,
      icon: icon ?? this.icon,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      instructor: instructor ?? this.instructor,
      isFavorite: isFavorite ?? this.isFavorite,
      enrolled: enrolled ?? this.enrolled,
    );
  }
}
