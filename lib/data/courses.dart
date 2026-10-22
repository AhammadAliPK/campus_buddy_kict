import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    'Monday',
    Icons.phone_iphone,
    '08:30 - 11:30',
    'KICT Lab 3',
    'Dr. Ahammad Ali',
  ),
  Course(
    'CSCI 3302',
    'Network Security',
    3,
    'Tuesday',
    Icons.security,
    '10:00 - 11:30',
    'KICT LT 2',
    'Dr. Noor Azura',
  ),
  Course(
    'CSCI 3301',
    'Computer Networks',
    3,
    'Wednesday',
    Icons.lan,
    '14:00 - 15:30',
    'KICT Lab 1',
    null, // Tests the TBA fallback
  ),
  Course(
    'CSCI 1301',
    'Object Oriented Programming',
    3,
    'Thursday',
    Icons.code,
    '11:30 - 13:00',
    'KICT LT 1',
    'Assoc. Prof. Dr. Amir',
  ),
  Course(
    'CSCI 2305',
    'Database Systems',
    3,
    'Friday',
    Icons.storage,
    '09:00 - 10:30',
    'KICT Lab 2',
    null, // Tests the TBA fallback
  ),
];