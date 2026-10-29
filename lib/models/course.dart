//This class holds no code for looks or behaviour — only data: what a course is. That is called a model

import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final String time;
  final String venue;
  final IconData icon;
  final String? instructor;
  final bool isFavorite;   // NEW: true when the user stars this course
  final bool enrolled;     // NEW: true when the user enrols in it

  const Course(this.code, this.name, this.creditHours, this.day, this.time,
      this.venue, this.icon,
      {this.instructor, this.isFavorite = false, this.enrolled = false});
  // { } = optional extras. If you leave them out: instructor = null,
  // isFavorite = false, enrolled = false. So courses.dart needs NO changes.

  Course copyWith({bool? isFavorite, bool? enrolled}) => Course(
        // "make a copy of me, maybe with a new star / enrolled value"
        code, name, creditHours, day, time, venue, icon,  // copy every field as-is
        instructor: instructor,                           // keep the instructor
        isFavorite: isFavorite ?? this.isFavorite,        // new value if given, else old one
        enrolled: enrolled ?? this.enrolled,
      );
}