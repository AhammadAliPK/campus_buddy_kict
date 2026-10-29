import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course('CSCI 4311', 'Mobile Application Development', 3, 'Monday', Icons.phone_iphone, '09:00-10:30', 'LT A', 'Dr. Ahammad'),
  Course('CSCI 1301', 'Object Oriented Programming', 3, 'Tuesday', Icons.code, '11:00-12:30', 'Lab 1', null),
  Course('CSCI 4333', 'Cryptography', 3, 'Wednesday', Icons.security, '14:00-15:30', 'LT B', 'Dr. Smith'),
  Course('CSCI 4336', 'Network Security', 3, 'Monday', Icons.router, '11:30-13:00', 'Lab 2', 'Prof. John'),
  Course('CSCI 4321', 'Ethical Hacking', 3, 'Friday', Icons.bug_report, '10:00-11:30', 'LT C', null),
];