import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  
  // Homework: Added time, venue, and nullable instructor
  final String time;
  final String venue;
  final String? instructor; 

  const Course(
    this.code, 
    this.name, 
    this.creditHours, 
    this.day, 
    this.icon, 
    this.time, 
    this.venue, 
    this.instructor
  );
}