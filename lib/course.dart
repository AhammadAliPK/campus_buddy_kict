import 'package:flutter/material.dart';

/// Model class: holds the data for one course. No widgets, no behaviour.
class Course {
  final String code;
  final String name;
  final int creditHours;
  final List<String> days; // a course can meet on several days
  final String time;
  final String venue;
  final String lecturer;
  final IconData icon;

  const Course(
    this.code,
    this.name,
    this.creditHours,
    this.days,
    this.time,
    this.venue,
    this.lecturer,
    this.icon,
  );

  /// Short text for the row, e.g. "Tue, Thu" or "TBA".
  String get daysLabel =>
      days.isEmpty ? 'TBA' : days.map((d) => d.substring(0, 3)).join(', ');
}

// Semester 1, 2026/2027 timetable.
const courses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    ['Tuesday', 'Thursday'],
    '3:30 PM - 4:50 PM',
    'ICT LR 13 Level 2D',
    'Poyilikandiyil Ahammad Ali',
    Icons.phone_iphone,
  ),
  Course(
    'CSCI 4320',
    'Software Testing',
    3,
    ['Tuesday', 'Thursday'],
    '11:30 AM - 12:50 PM',
    'ICT TL-E5-03',
    'Normi Sham Bt. Awang Abu Bakar',
    Icons.bug_report,
  ),
  Course(
    'CSCI 4334',
    'Network and Systems Administration',
    3,
    ['Tuesday', 'Thursday'],
    '2:00 PM - 3:30 PM',
    'ICT CISCO LAB2',
    'Adamu Abubakar Ibrahim',
    Icons.dns,
  ),
  Course(
    'CSCI 4402',
    'Final Year Project II',
    4,
    ['Friday'],
    '11:30 AM - 12:50 PM',
    'ICT LT 1 Level 4D',
    'Ahmad Anwar Bin Zainuddin',
    Icons.school,
  ),
];
