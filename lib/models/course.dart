import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final bool isEnrolled; // Added for the Checkbox toggle

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon, {
    this.isEnrolled = false,
  });

  // copyWith method to replace the object with a single change
  Course copyWith({
    String? code,
    String? name,
    int? creditHours,
    String? day,
    IconData? icon,
    bool? isEnrolled,
  }) {
    return Course(
      code ?? this.code,
      name ?? this.name,
      creditHours ?? this.creditHours,
      day ?? this.day,
      icon ?? this.icon,
      isEnrolled: isEnrolled ?? this.isEnrolled,
    );
  }
}