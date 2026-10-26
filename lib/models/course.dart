import 'package:flutter/material.dart';
class Course {
final String code;
final String name;
final int creditHours;
final List<String> days;
final IconData icon;
final String time; 
final String venue;
final String? instructor;
const Course(this.code, this.name, this.creditHours, this.days, this.icon, this.time, this.venue, this.instructor);
}