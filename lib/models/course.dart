//This class holds no code for looks or behaviour — only data: what a course is. That is called a model

import 'package:flutter/material.dart';

class Course {  // a "blueprint" describing what a course is
  final String code;  // final = can't change once set
  final String name;
  final int creditHours;
  final String day;
  final String time;         //e.g. '09:00–10:30'
  final String venue;
  final IconData icon;  // which icon to show for this course
  final String? instructor;

  const Course(this.code, this.name, this.creditHours, this.day, this.time, this.venue, this.icon, {this.instructor});  // the constructor: how you MAKE a course. The values go in this order: // Course('CSCI 4311', 'Mobile App Dev', 3, 'Monday', '09:00–10:30', 'Building A, Room 101', Icons.phone_iphone)
}