import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const sampleCourses = [
  Course(
    code: 'CSCI 4311',
    name: 'Mobile Application Development',
    lecturer: 'Dr. Ali',
    day: 'Monday',
    time: '08:00 - 10:00',
    icon: Icons.phone_iphone,
  ),
  Course(
    code: 'CSCI 4321',
    name: 'Data Structures and Algorithms',
    lecturer: 'Dr. Smith',
    day: 'Tuesday',
    time: '10:00 - 12:00',
    icon: Icons.settings,
  ),
  Course(
    code: 'CSCI 4331',
    name: 'Database Systems',
    lecturer: 'Dr. Johnson',
    day: 'Wednesday',
    time: '14:00 - 16:00',
    icon: Icons.storage,
  ),
];
