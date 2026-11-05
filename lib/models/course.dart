import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
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

/* import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final String time;
  final String venue;
  final String? instructor;

  // Week 5: New fields
  final bool isFavorite;
  final bool enrolled;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon,
    this.time,
    this.venue,
    this.instructor, {
    this.isFavorite = false,
    this.enrolled = false,
  });

  // Week 5: Create an updated copy of a course
  Course copyWith({bool? isFavorite, bool? enrolled}) {
    return Course(
      code,
      name,
      creditHours,
      day,
      icon,
      time,
      venue,
      instructor,
      isFavorite: isFavorite ?? this.isFavorite,
      enrolled: enrolled ?? this.enrolled,
    );
  }
}*/
