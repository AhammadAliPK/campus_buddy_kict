import 'package:flutter/material.dart';

class Course{
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final String time;
  final String venue;
  final String? instructor;
  final IconData icon;
  final bool isFavourite;
  final bool enrolled;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.time,
    this.venue,
    this.icon,
    {this.instructor,this.isFavourite = false, this.enrolled = false}
  );
  Course copyWith({bool? isFavourite, bool? enrolled}) => Course(
    code, name, creditHours, day, time, venue, icon,
    instructor: instructor,
    isFavourite: isFavourite ?? this.isFavourite,
    enrolled: enrolled ?? this.enrolled,
  );
}