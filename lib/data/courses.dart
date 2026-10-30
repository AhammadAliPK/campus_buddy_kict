
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    'Monday',
    Icons.phone_iphone,
    '09:00–10:30',
    'LT A',
    instructor: 'Dr. Ahmad',
  ),
  Course(
    'CSCI 1301',
    'Object Oriented Programming',
    3,
    'Tuesday',
    Icons.code,
    '11:00–12:30',
    'Lab 2',
    instructor: 'Dr. Siti',
  ),
  Course(
    'CSCI 2301',
    'Computer Networks',
    3,
    'Wednesday',
    Icons.computer,
    '14:00–15:30',
    'LT B',
  ),
];
