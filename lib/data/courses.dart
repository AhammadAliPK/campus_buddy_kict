import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course('CSEC 3301', 'Digital Evidence Forensics', 3, 'Monday', Icons.search, '09:00-10:30', 'KICT Lab 1', 'Dr. Andi Fitriah Abdul Kadir'),
  Course('CSEC 3302', 'Enterprise Network', 3, 'Tuesday', Icons.router, '11:00-12:30', 'LT A'),
  Course('CSEC 3303', 'Cryptography', 3, 'Wednesday', Icons.lock, '14:00-15:30', 'LT B', 'Dr. Adam'),
  Course('CSEC 3304', 'Network and Systems Admin', 3, 'Thursday', Icons.computer, '10:00-11:30', 'KICT Lab 2'),
  Course('CSCI 4311', 'Mobile App Development', 3, 'Friday', Icons.phone_iphone, '16:00-17:30', 'Lab 3'),
];