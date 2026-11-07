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
  final bool isFavorite; 
  final bool enrolled; 

  const Course(this.code, this.name, this.creditHours, this.day, this.time, this.venue, this.instructor, this.icon, 
      {this.isFavorite = false, this.enrolled = false}); 

  Course copyWith({bool? isFavorite, bool? enrolled}) => Course(
        code, name, creditHours, day, time, venue, instructor, icon,
        isFavorite: isFavorite ?? this.isFavorite,
        enrolled: enrolled ?? this.enrolled,
      );
}