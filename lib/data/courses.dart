import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',3,
    'Tuesday', Icons.phone_iphone,
  ),
  Course(
    'CSCI 4320', 
    'Software Testing',
     3, 'Thursday', Icons.bug_report),
  Course(
    'CSCI 4340', 
    'Machine Learning', 
    3, 'Monday', Icons.engineering),
  Course(
    'CCFA 2010', 
    'First Aid Skills', 
    3, 'Wednesday', Icons.healing),
  Course(
    'CSCI 4402', 
    'Final Year Project II', 
    3, 'Friday', Icons.assignment),
];
