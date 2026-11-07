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
  });

  Course copyWith({
    String? code,
    String? name,
    int? creditHours,
    String? day,
    IconData? icon,
    bool? isFavorite,
  }) =>
      Course(
        code ?? this.code,
        name ?? this.name,
        creditHours ?? this.creditHours,
        day ?? this.day,
        icon ?? this.icon,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}