
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    code: 'CSCI 4340',
    name: 'Machine Learning',
    creditHours: 3,
    day: 'Monday',
    icon: Icons.phone_android,
    time: '08:30',
    venue: 'ICT LR 13 LEVEL 2D',
    instructor: 'Dr. Amir',
  ),
  Course(
    code: 'CSCI 4311',
    name:'Mobile Application Development',
    creditHours: 3,
    day: 'Tuesday',
    icon: Icons.computer,
    venue: 'ICT Teach Lab 13',
    time: '14:00',
    instructor: 'Dr. Ahammad',
  ),
  Course(
    code:'CSCI 4332',
    name:'Digital Evidence Forensics',
    creditHours: 3,
    day:'Wednesday',
    icon: Icons.code,
    venue: 'ICT LT 1 LEVEL 4D',
    time: '11:30',
    instructor: 'Dr. Andi',
  ),
  Course(
    code:'CSCI 4310',
    name:'Requirements Engineering',
    creditHours: 3,
    day:'Thursday',
    icon: Icons.storage,
    venue: 'ICT LR 13 LEVEL 2D',
    time: '10:00',
    instructor: 'Dr. Azlin',
  ),
  Course(
    code:'CSCI 4402',
    name:'Final Year Project II',
    creditHours: 4,
    day:'Friday',
    icon: Icons.wifi,
    venue: 'ICT LR 14A LEVEL 2D',
    time: '11:30',
    instructor: 'Dr. Anwar',
  ),
];
