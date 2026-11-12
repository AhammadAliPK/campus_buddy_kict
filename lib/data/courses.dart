import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course('CSCI 4311', 'Mobile Application Development', 3,
      'Monday', Icons.phone_iphone, '09:00-10:20', 'LT A',
      instructor: 'Dr. Ahammad Ali'),
  Course('CCSM 2010', 'Smart Money Management 2', 1,
      'Tuesday', Icons.attach_money, '14:00-15:50', 'CR 3'),
  Course('INFO 4330', 'Control and Audit of Information Systems', 3,
      'Wednesday', Icons.security, '11:00-12:20', 'LT B'),
  Course('INFO 4343', 'Information Privacy', 3,
      'Thursday', Icons.privacy_tip, '08:30-09:50', 'CR 7'),
  Course('INFO 4402', 'Final Year Project II', 4,
      'Friday', Icons.assignment, '10:00-12:00', 'Lab 2'),
];