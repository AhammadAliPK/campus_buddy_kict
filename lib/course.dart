import 'package:flutter/material.dart';

/// One subject in the timetable: data only, no widgets.
class Course {
  final String code;
  final String name;
  final int creditHours;
  final List<String> days; // empty = no fixed day yet
  final String time;
  final IconData icon;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.days,
    this.time,
    this.icon,
  );

  /// Short text for the list row, e.g. 'Tue, Thu' or 'TBA'.
  String get daysLabel =>
      days.isEmpty ? 'TBA' : days.map((d) => d.substring(0, 3)).join(', ');
}

const courses = [
  Course('CSCI 4311', 'Mobile Application Development', 3,
      ['Tuesday', 'Thursday'], '3.30 - 4.50 PM', Icons.phone_iphone),
  Course('CSCI 4320', 'Software Testing', 3, ['Tuesday', 'Thursday'],
      '10.00 - 11.20 AM', Icons.bug_report),
  Course('CSCI 4334', 'Network and Systems Administration', 3,
      ['Tuesday', 'Thursday'], '2.00 - 3.20 PM', Icons.dns),
  Course('CSCI 4402', 'Final Year Project II', 4, ['Friday'],
      '11.30 AM - 12.50 PM', Icons.school),
];

const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
