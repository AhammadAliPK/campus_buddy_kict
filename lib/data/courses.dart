//Data lives in its own file. Next week, when the list can be edited, this file just gives the starting values.

import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';  // so this file knows what a Course is

const List<Course> sampleCourses = [   // one list holding all your courses
  Course('CSCI 4340', 'Machine Learning', 3, 'Thursday', '08:30–09:50', 'Lab PC', Icons.account_tree),
  Course('CSCI 4311', 'Mobile Application Development', 3, 'Tuesday', '15:30–16:50', 'Everywhere', Icons.phone_iphone, instructor: 'Dr. Ali'),
  Course('CSCI 1301', 'Object Oriented Programming', 3, 'Monday', '10:00–11:20', 'Lab 1', Icons.code),
  Course('CSCI 4334', 'Network and Systems Administration', 3, 'Tuesday', '14:00–15:20', 'Lab 4', Icons.terminal),
  Course('CSCI 4341', 'Data Science', 3, 'Thursday', '00:00–01:20', 'Toilet Ground Floor', Icons.data_array),
];