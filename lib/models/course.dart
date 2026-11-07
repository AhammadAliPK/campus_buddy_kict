import 'package:flutter/material.dart';

class Course {
  final String code; // 'CSCI 4311'
  final String name; // 'Mobile Application Development'
  final int creditHours; // 3
  final IconData icon; // Icons.phone_iphone
  final String day; // 'Monday'
  final bool isFavorite; // true when the user stars this course
  final bool enrolled; // true when the user enrolls in it

  const Course(this.code, this.name, this.creditHours, this.icon, this.day,
      {this.isFavorite = false, this.enrolled = false});

  // make a copy with one difference
  Course copyWith({bool? isFavorite, bool? enrolled}) => Course(
        code, name, creditHours, icon, day,
        isFavorite: isFavorite ?? this.isFavorite,
        enrolled: enrolled ?? this.enrolled,
      );
}
