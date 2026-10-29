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
final bool isFavorite; // ← NEW: true when the user stars this course
final bool enrolled;
const Course(this.code, this.name, this.creditHours, this.days, this.icon, this.time, this.venue, this.instructor,
{this.isFavorite = false, this.enrolled = false});
Course copyWith({bool? isFavorite, bool? enrolled}) => Course(
  code, name, creditHours, days, icon, time, venue, instructor,
  isFavorite: isFavorite ?? this.isFavorite,
  enrolled: enrolled ?? this.enrolled,
  );
}