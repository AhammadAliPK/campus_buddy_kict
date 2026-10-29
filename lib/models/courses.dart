import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final String time;        // ← Added time
  final String venue;       // ← Added venue
  final String? instructor;

  final bool isFavourite;
  final bool isEnrolled;

  const Course(this.code, this.name, this.creditHours, this.day, this.icon,
      this.time, this.venue, {this.instructor, this.isFavourite = false, this.isEnrolled = false});
  
  Course copyWith ({bool? isFavourite, bool? isEnrolled}) => Course(
    code, name, creditHours, day, icon, time, venue, instructor: instructor,
    isFavourite: isFavourite ?? this.isFavourite,
    isEnrolled: isEnrolled ?? this.isEnrolled,
  );
  
}
