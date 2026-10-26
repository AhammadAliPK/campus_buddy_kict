import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    'Tuesday | Thursday ',
    Icons.code,
  ),
  Course('CSCI 4320', 'Software Testing', 3, 'Tuesday | Thursday', Icons.code),
  Course(
    'CSCI 4341',
    'Big Data Analytics',
    3,
    'Monday | Wednesday',
    Icons.code,
  ),
  Course('CSCI 4402', 'Final Year Project II', 4, 'Friday', Icons.code),
  Course('INFO 4303', 'Technopreneurship', 3, 'Tuesday | Thursday', Icons.code),
];
