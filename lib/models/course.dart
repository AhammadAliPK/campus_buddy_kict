import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final String time;
  final String venue;
  final bool isFavourite;
  final bool enrolled;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon,
    this.time,
    this.venue, {
    this.isFavourite = false,
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
    bool? isFavourite,
    bool? enrolled,
  }) => Course(
    code ?? this.code,
    name ?? this.name,
    creditHours ?? this.creditHours,
    day ?? this.day,
    icon ?? this.icon,
    time ?? this.time,
    venue ?? this.venue,
    isFavourite: isFavourite ?? this.isFavourite,
    enrolled: enrolled ?? this.enrolled,
  );
}
