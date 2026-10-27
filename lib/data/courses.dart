import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

/// Your timetable for this week — replace these with the courses you actually
/// take (the lab asks for at least 5).
///
/// `instructor` is optional: leave it out and the row shows 'TBA'.
const List<Course> sampleCourses = [
  Course('CSCI 4311', 'Mobile Application Development', 3, 'Monday',
      '09:00-10:30', 'LT A', Icons.phone_iphone),
  Course('CSCI 1301', 'Object Oriented Programming', 3, 'Tuesday',
      '09:00-10:30', 'Lab 2', Icons.code),
  Course('CSCI 2303', 'Data Structures and Algorithms', 3, 'Wednesday',
      '11:00-12:30', 'LT B', Icons.account_tree),
  Course('CSCI 3305', 'Database Systems', 3, 'Thursday', '14:00-15:30',
      'Lab 4', Icons.storage),
  Course('INFO 2301', 'Systems Analysis and Design', 3, 'Friday',
      '08:00-09:30', 'LT C', Icons.design_services),
  Course('CSCI 4312', 'Software Engineering', 3, 'Tuesday', '11:00-12:30',
      'LT A', Icons.build),
];
