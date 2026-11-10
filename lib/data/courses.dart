import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

// TODO: replace the times, venues and instructors with your real timetable
const List<Course> sampleCourses = [
  Course('CSCI 4311', 'Mobile Application Development', 3,
      'Tuesday', Icons.phone_iphone,
      time: '09:00–10:30', venue: 'LT A'),
  Course('CSCI 4401', 'Cryptography', 3,
      'Monday', Icons.lock,
      time: '11:00–12:30', venue: 'LT B'),
  Course('CSCI 4320', 'Software Testing', 3,
      'Wednesday', Icons.bug_report,
      time: '14:00–15:30', venue: 'LT C'),
  Course('LMCK 1011', 'Cooking Skills', 1,
      'Thursday', Icons.restaurant,
      time: '16:00–17:00', venue: 'Kitchen Lab'),
  Course('CSCI 4350', 'Brain Data Analytics', 3,
      'Monday', Icons.psychology,
      time: '08:30–10:00', venue: 'Lab 2'),
];
