import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course('CSCI 4311', 'Mobile Application Development', 3, 'Monday', '09:00-10:30', 'LT A', 'Dr. Ahmad', Icons.phone_iphone),
  Course('CSCI 1301', 'Object Oriented Programming', 3, 'Tuesday', '11:00-12:30', 'LT B', null, Icons.code),
  Course('CSCI 2104', 'Data Structures', 3, 'Wednesday', '14:00-15:30', 'Lab 2', 'Prof. Siti', Icons.account_tree),
  Course('CSCI 3302', 'Operating Systems', 3, 'Thursday', '10:00-11:30', 'LT C', null, Icons.computer),
  Course('CSCI 4401', 'Final Year Project', 3, 'Friday', '16:00-17:30', 'IoT Lab', 'Dr. Supervisor', Icons.memory),
];