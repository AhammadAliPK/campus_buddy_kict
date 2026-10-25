//Data lives in its own file. Next week, when the list can be edited, this file just gives the starting values.

import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';  // so this file knows what a Course is

const List<Course> sampleCourses = [   // one list holding all your courses
  Course('CSCI 4311', 'Mobile Application Development', 3, 'Monday', Icons.phone_iphone),
  Course('CSCI 1301', 'Object Oriented Programming', 3, 'Tuesday', Icons.code),
  Course('CSCI 4334', 'Network and Systems Administration', 3, 'Tuesday', Icons.terminal),
  Course('CSCI 4340', 'Machine Learning', 3, 'Thursday', Icons.account_tree),
  Course('CSCI 4341', 'Data Science', 3, 'Thursday', Icons.data_array),
];