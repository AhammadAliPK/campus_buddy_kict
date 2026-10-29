import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final String venue; 
  final String? instructor; 
  final bool isFavorite; // NEW
  final bool enrolled;   // NEW

  const Course(
      this.code, this.name, this.creditHours, this.day, this.icon, this.venue, this.instructor,
      {this.isFavorite = false, this.enrolled = false}); // CHANGED

  // NEW method to duplicate a course and change its status
  Course copyWith({bool? isFavorite, bool? enrolled}) => Course(
        code, name, creditHours, day, icon, venue, instructor,
        isFavorite: isFavorite ?? this.isFavorite,
        enrolled: enrolled ?? this.enrolled,
      );
}