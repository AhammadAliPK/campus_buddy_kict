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
    this.instructor,
    this.isFavourite = false,
    this.enrolled = false,
  });
  Course copyWith({
    String? name,
    int? creditHours,
    String? time,
    String? venue,
    String? instructor,
    // null instructor means "keep", so this flag is needed to go back to TBA
    bool clearInstructor = false,
    bool? isFavourite,
    bool? enrolled,
  }) => Course(
    code,
    name ?? this.name,
    creditHours ?? this.creditHours,
    days,
    time ?? this.time,
    venue ?? this.venue,
    icon,
    instructor: clearInstructor ? null : (instructor ?? this.instructor),
    isFavourite: isFavourite ?? this.isFavourite,
    enrolled: enrolled ?? this.enrolled,
  );
}
