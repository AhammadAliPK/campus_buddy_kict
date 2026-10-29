import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final String time;
  final String? instructor;
  final String venue;
  
  const Course(this.code, this.name, this.creditHours, this.day, this.icon, this.time, this.instructor, this.venue);
}