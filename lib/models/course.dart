import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final String time;
  final String venue;
  final String? instructor;
  final IconData icon;
 

  const Course(this.code, this.name, this.creditHours, this.day, this.time, this.venue, this.instructor, this.icon );
}