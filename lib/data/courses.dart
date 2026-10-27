import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course('CSCI 4300', 'Computation and Complexity', 3, 'Monday', Icons.memory, '10:00-11:20 AM', 'TL-D4-03', instructor: 'Dr. Liyana'),
  Course('CSCI 4300', 'Computation and Complexity', 3, 'Wednesday', Icons.memory, '10:00-11:20 AM', 'TL-D4-03', instructor: 'Dr. Liyana'),
  Course('CSCI 4311', 'Mobile Application Development', 3, 'Tuesday', Icons.phone_iphone, '3:30-4:50 PM', 'LR 13 LEVEL 2D', instructor: 'Sir Ahamad Ali'),
  Course('CSCI 4311', 'Mobile Application Development', 3, 'Thursday', Icons.phone_iphone, '3:30-4:50 PM', 'LR 13 LEVEL 2D', instructor: 'Sir Ahamad Ali'),
  Course('CSCI 4320', 'Software Testing', 3, 'Tuesday', Icons.bug_report, '10:00-11:20 AM', 'TL-E5-03 LEVEL 5E'),
  Course('CSCI 4320', 'Software Testing', 3, 'Thursday', Icons.bug_report, '10:00-11:20 AM', 'TL-E5-03 LEVEL 5E'),
  Course('CSCI 4402', 'Final Year Project II', 4, 'Friday', Icons.school, '11:30-12:50 PM', 'LT 1 LEVEL 4D', instructor: 'Dr Anwar'),
  Course('INFO 4304', 'ICT and Islam', 3, 'Tuesday', Icons.menu_book, '11:30-12:50 AM', 'CITA RESOURCE ROOM'),
  Course('INFO 4304', 'ICT and Islam', 3, 'Thursday', Icons.menu_book, '11:30-12:50 AM', 'CITA RESOURCE ROOM'),
  Course('SCSH 3164', 'Usrah in Action 2', 1, 'Wednesday', Icons.group, '8:00-9:00 PM', 'TBA'),
];