
import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final bool isFavorite;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon, {
      this.isFavorite = false,
    }
  );

  Course copyWith({ bool? isFavorite }) {
   
    return Course(
      code,
      name,
      creditHours,
      day,
      icon,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
