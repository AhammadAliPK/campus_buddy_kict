import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  //final String time;
  //final String venue;
  final bool isFavourite;
  final bool enrolled;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon, {
    //this.time,
    //this.venue,
    this.isFavourite = false,
    this.enrolled = true,
  });

  Course copyWith({bool? isFavourite, bool? enrolled}) => Course(
    code,
    name,
    creditHours,
    day,
    icon,
    //time,
    //venue,
    isFavourite: isFavourite ?? this.isFavourite,
    enrolled: enrolled ?? this.enrolled,
  );
}
