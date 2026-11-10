import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

// My real timetable (registered courses)
const List<Course> sampleCourses = [
  Course('CCCK 1010', 'Cooking Skills', 0.5,
      ['Tuesday'], Icons.restaurant,
      time: '17:00–19:00', venue: 'Cooking Room, Wadi Budi',
      instructor: 'Basaruddin Adam'),
  Course('CSCI 4311', 'Mobile Application Development', 3,
      ['Tuesday', 'Thursday'], Icons.phone_iphone,
      time: '14:00–15:20', venue: 'ICT LR 13, Level 2D',
      instructor: 'Poyilikandiyil Ahammad Ali'),
  Course('CSCI 4320', 'Software Testing', 3,
      ['Tuesday', 'Thursday'], Icons.bug_report,
      time: '10:00–11:20', venue: 'ICT TL-E5-01, Level 5E',
      instructor: 'Normi Sham bt. Awang Abu Bakar'),
  Course('CSCI 4333', 'Cryptography', 3,
      ['Tuesday', 'Thursday'], Icons.lock,
      time: '11:30–12:50', venue: 'ICT LR 14A, Level 2D',
      instructor: 'Takumi Sase'),
  Course('CSCI 4402', 'Final Year Project II', 4,
      ['Friday'], Icons.school,
      time: '11:30–12:50', venue: 'ICT LT 1, Level 4D',
      instructor: 'Ahmad Anwar bin Zainuddin'),
];
