import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final String time;        // NEW
  final String venue;       // NEW
  final String? instructor; // NEW (nullable)

  // Added as positional arguments, with instructor in optional brackets []
  const Course(this.code, this.name, this.creditHours, this.day, this.icon, this.time, this.venue, [this.instructor]);
}