import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final bool isFavorite; // true when the user stars this course
  final bool enrolled; // true when the user enrolls in it

  // two optional extras in {curly braces}, both default to false
  const Course(this.code, this.name, this.creditHours, this.day, this.icon,
      {this.isFavorite = false, this.enrolled = false});

  // make a copy with one difference
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
