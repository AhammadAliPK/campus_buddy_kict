
import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    'Monday',
    Icons.phone_iphone,
    time: '09:00–10:30',
    venue: 'LT A',
    instructor: 'Dr. Ali',
  ),
  Course(
    'CSCI 4340',
    'Machine Learning',
    3,
    'Tuesday',
    Icons.code,
    time: '08:30–10:00',
    venue: 'Lab 1',
  ),
  Course(
    'CSCI 4312',
    'Blockchain and Application',
    3,
    'Tuesday',
    Icons.code,
    time: '10:00–11:30',
    venue: 'LT B',
    instructor: 'Dr. Norbik',
  ),
  Course(
    'CSCI 4347',
    'Brain Computational Analysis',
    3,
    'Tuesday',
    Icons.code,
    time: '14:00–15:30',
    venue: 'Lab 2',
  ),
  Course(
    'CSCI 4310',
    'Introduction to Quantum Computing',
    3,
    'Tuesday',
    Icons.code,
    time: '16:00–17:30',
    venue: 'LT C',
  ),
];
