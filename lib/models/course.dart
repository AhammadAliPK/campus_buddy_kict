
import 'package:flutter/material.dart';

class Course {
  final String code;
  final String name;
  final int creditHours;
  final String day;
  final IconData icon;
  final bool isFavorite;
  final bool enrolled;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.day,
    this.icon, {
    this.isFavorite = false,
    this.enrolled = false,
  });

  Course copyWith({
    String? code,
    String? name,
    int? creditHours,
    String? day,
    bool? isFavorite,
    bool? enrolled,
  }) => Course(
    code ?? this.code,
    name ?? this.name,
    creditHours ?? this.creditHours,
    day ?? this.day,
    icon,
    isFavorite: isFavorite ?? this.isFavorite,
    enrolled: enrolled ?? this.enrolled,
  );
}
