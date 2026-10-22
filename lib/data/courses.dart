import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CSCI 4300',
    'Computation and Complexity',
    3,
    'Monday',
    Icons.phone_iphone,
  ),
  Course('CSCI 4320', 'Software Testing', 3, 'Tuesday', Icons.lightbulb),
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    'Wednesday',
    Icons.security,
  ),
  Course('CCSL 1010', 'Malaysian Sign Language I', 3, 'Thursday', Icons.router),
  Course('CSCI 4402', 'Final Year Project II', 3, 'Friday', Icons.menu_book),
];
