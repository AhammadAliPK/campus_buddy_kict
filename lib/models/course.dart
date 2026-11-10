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

  Course copyWith({
    String? name, int? creditHours, String? day,      // NEW: editable fields
    String? time, String? venue,                      // NEW
    bool? isFavorite, bool? enrolled,                 // already had these
  }) => Course(
        code,                                         // code never changes
        name ?? this.name,                            // new value if given, else keep old
        creditHours ?? this.creditHours,
        day ?? this.day,
        time ?? this.time,
        venue ?? this.venue,
        icon,
        instructor: instructor,
        isFavorite: isFavorite ?? this.isFavorite,
        enrolled: enrolled ?? this.enrolled,
      );
}