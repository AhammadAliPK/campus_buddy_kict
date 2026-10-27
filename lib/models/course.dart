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
  final bool isEnrolled;

  const Course(
    this.code, 
    this.name, 
    this.creditHours, 
    this.day, 
    this.icon,
    this.time,
    this.venue,
    [this.instructor], {
    this.isFavorite = false,
    this.isEnrolled = false,
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
    bool? isEnrolled,
  }) {
    return Course(
      code ?? this.code,
      name ?? this.name,
      creditHours ?? this.creditHours,
      day ?? this.day,
      icon ?? this.icon,
      time ?? this.time,
      venue ?? this.venue,
      instructor ?? this.instructor,
      isFavorite: isFavorite ?? this.isFavorite,
      isEnrolled: isEnrolled ?? this.isEnrolled,
    );
  }
}