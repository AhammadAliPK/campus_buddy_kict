import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    'Monday',
    Icons.phone_iphone,
  ),
  Course('CSCI 1301', 'Object Oriented Programming', 3, 'Tuesday', Icons.code),
  Course('INFO 1103', 'Database Systems', 3, 'Wednesday', Icons.storage),
  Course('CSCI 2300', 'Web Engineering', 3, 'Thursday', Icons.web),
  Course('INFO 2302', 'Data Structures', 3, 'Friday', Icons.account_tree),
];
