import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final String venue; 
  final String? instructor; 
  final bool isFavorite;
  final bool enrolled;

  const Course(
      this.code, this.name, this.creditHours, this.day, this.icon, this.venue, this.instructor,
      {this.isFavorite = false, this.enrolled = false}
  );

  Course copyWith({
    String? name,
    String? venue,
    bool? isFavorite, 
    bool? enrolled,
  }) => Course(
    code, 
    name ?? this.name, 
    creditHours, 
    day, 
    icon, 
    venue ?? this.venue, 
    instructor,
    isFavorite: isFavorite ?? this.isFavorite,
    enrolled: enrolled ?? this.enrolled,
  );
}