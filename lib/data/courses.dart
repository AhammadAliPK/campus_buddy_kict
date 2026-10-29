import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CCFM 2061',
    'Family Management',
    .5,
    'Tuesday',
    Icons.family_restroom,
    '9:00 AM - 9:50 AM',
    instructor: 'Dr. Ayesha',
    venue: 'Room 101',
  ),
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3.0,
    'Tuesday',
    Icons.phone_android,
    '10:00–11:30', // ADD: Example time.
    venue: 'Lab 2', // ADD: Example venue.
    // Instructor omitted → null → display TBA.
  ),
  Course(
    'CSCI 4341',
    'Big Data Analytics',
    3.0,
    'Monday',
    Icons.data_array_outlined,
    '09:00–10:30', // ADD: Example time.
    venue: 'LT A', // ADD: Example venue.
  ),
  Course(
    'INFO 4303',
    'Technopreneurship',
    3.0,
    'Tuesday',
    Icons.business_center_outlined,
    '12:00–13:30', // ADD: Example time.
    venue: 'Room 202', // ADD: Example venue.
  ),
  Course(
    'INFO 4304',
    'ICT ans Islam',
    3.0,
    'Tuesday',
    Icons.handyman,
    '14:00–15:30', // ADD: Example time.
    venue: 'Room 203', // ADD: Example venue.
  ),
];
