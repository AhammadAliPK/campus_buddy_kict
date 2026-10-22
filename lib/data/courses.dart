import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/courses.dart';

const List<Course> sampleCourses = [
  Course(
    code: 'CSCI 4311',
    name: 'Mobile Application Development',
    creditHours: 3,
    day: 'Monday',
    icon: Icons.phone_iphone,
  ),
  Course(
    code: 'CSCI 1301',
    name: 'Object Oriented Programming',
    creditHours: 3,
    day: 'Tuesday',
    icon: Icons.code,
  ),
  Course(
    code: 'CSCI 1302',
    name: 'Data Structures and Algorithms',
    creditHours: 3,
    day: 'Wednesday',
    icon: Icons.storage,
  ),
  Course(
    code: 'CSCI 1303',
    name: 'Database Systems',
    creditHours: 3,
    day: 'Thursday',
    icon: Icons.storage,
  ),
];