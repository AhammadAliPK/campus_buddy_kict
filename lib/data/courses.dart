import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    'Monday',
    Icons.phone_iphone,
    time: '10:00 - 11:30',
    venue: 'Lab 3, KICT',
    instructor: 'Dr. Ahammad Ali',
  ),
  Course(
    'INFO 3303',
    'System Administrator',
    3,
    'Tuesday, Thursday',
    Icons.cloud,
    time: '14:00 - 15:30',
    venue: 'TR 2, KICT',
    instructor: 'Dr. Adamu', // Displays TBA
  ),
  Course(
    'INFO 3302',
    'Digital Forensics',
    3,
    'Tuesday',
    Icons.security,
    time: '08:30 - 10:00',
    venue: 'Cyber Lab 1',
    instructor: 'Dr. Andi',
  ),
  Course(
    'CSCI 3301',
    'Penetration Testing',
    3,
    'Wednesday',
    Icons.terminal,
    time: '11:30 - 13:00',
    venue: 'Networking Lab',
    instructor: 'Dr. Zaki',
  ),
  Course(
    'INFO 4301',
    'Network Security Administration',
    3,
    'Thursday',
    Icons.shield,
    time: '10:00 - 11:30',
    venue: 'Cisco Lab',
    instructor: null, // Displays TBA
  ),
];
