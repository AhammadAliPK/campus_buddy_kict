import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

// Session 2026/2027, 1 (from the course registration confirmation slip)
const List<Course> sampleCourses = [
  Course('CSCI 4311', 'Mobile Application Development', 3,
      'Tue & Thu', '3:30–4:50 PM', 'ICT LR 13 LEVEL 2D', Icons.phone_iphone),
  Course('CSCI 4320', 'Software Testing', 3,
      'Tue & Thu', '10:00–11:20 AM', 'ICT TL-E5-03 LEVEL 5E', Icons.bug_report),
  Course('CSCI 4322', 'Software Design and Architecture', 3,
      'Tue & Thu', 'TBA', 'TBA', Icons.architecture),
  Course('INFO 4303', 'Technopreneurship', 3,
      'Tue & Thu', '11:30 AM–12:50 PM', 'ICT CITA PBL LAB LEVEL 1B',
      Icons.lightbulb),
  Course('CSCI 4402', 'Final Year Project II', 4,
      'Fri', '11:30 AM–12:50 PM', 'ICT LT 1 LEVEL 4D', Icons.school),
  Course('CCCK 1010', 'Cooking Skills', 0.5,
      'Tue', '8:00–10:00 PM', 'TBA', Icons.restaurant),
];
