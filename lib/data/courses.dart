import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course('CSCI 4311', 'Mobile Application Development', 3,
    'Monday', Icons.phone_iphone, 
    time: '14:00-15:20', venue: 'ICT LR 13, Level 2D', instructor: 'Sir Poyilikandiyil'),

  Course('CSCI 4340', 'Machine Learning', 3,
    'Tuesday', Icons.computer_rounded,
    time: '08:00-09:20', venue: 'ICT TEACH LAB 4, Level 3C', instructor: 'Dr. Amir'),

  Course('CSCI 4343', 'Data Science', 3, 
    'Tuesday', Icons.bar_chart_rounded,
    time: '09:30-10:50', venue: 'ICT Teach Lab 8 (TL-D4-02), Level 4D', instructor: 'Dr. Raini'),

  Course('CSCI 4300', 'Computation and Complexity', 3, 
    'Tuesday', Icons.code,
    time: '11:00-12:50', venue: 'ICT LR 11, Level 2C', instructor: 'Dr. Yasir'),

  Course('CCAN 3442', 'Archery 4', 1, 
    'Friday', Icons.sports_soccer_rounded,
    time: '17:00-19:00', venue: 'Archery Field'),
];