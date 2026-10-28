import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    'Monday',
    '09:00–10:30',
    'LT A',
    Icons.phone_iphone,
    instructor: 'Dr. Ahmad',
  ),
  Course(
    'CSCI 1301',
    'Object Oriented Programming',
    3,
    'Tuesday',
    '10:00–12:00',
    'Lab 2',
    Icons.code,
  ),
  Course(
    'CSCI 2201',
    'Database Systems',
    3,
    'Wednesday',
    '14:00–16:00',
    'LT B',
    Icons.storage,
    instructor: 'Dr. Sarah',
  ),
  Course(
    'CSCI 3201',
    'Artificial Intelligence',
    3,
    'Thursday',
    '09:00–11:00',
    'Lab 1',
    Icons.smart_toy,
  ),
  Course(
    'CSCI 3301',
    'Software Engineering',
    3,
    'Friday',
    '11:00–13:00',
    'LT C',
    Icons.computer,
    instructor: 'Dr. Ali',
  ),
];
