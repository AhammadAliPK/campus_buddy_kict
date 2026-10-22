import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    ['Tuesday', 'Thursday'],
    '3:30pm–4:50pm',
    'LR13 Level 2D',
    Icons.phone_iphone,
    instructor: 'Poyilikandiyil Ahammad Ali',
  ),
  Course(
    'CSCI 4320',
    'Software Testing',
    3,
    ['Tuesday', 'Thursday'],
    '11:30am–12:50pm',
    'TL-E5-01 Level 5E',
    Icons.bug_report,
    instructor: 'Dr. Normi Sham Bt. Awang Abu Bakar',
  ),
  Course(
    'CSCI 4334',
    'Network and System Administration',
    3,
    ['Tuesday', 'Thursday'],
    '2:00pm–3:20pm',
    'Cisco Lab2 Level 4E',
    Icons.lan,
    instructor: 'Adamu Abubakar Ibrahim',
  ),
  Course(
    'CSCI 4402',
    'Final Year Project ii',
    4,
    ['Friday'],
    '11:30am–12:50pm',
    'LT 1 Level 4D',
    Icons.school,
    instructor: 'Ahmad Anwar Bin Zainuddin',
  ),
];
