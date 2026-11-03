import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [

  Course(
    'CSCI 4321', 
    'Project Management in Software Engineering', 
    3,
    'Monday', 
    Icons.engineering,
    // '10:00 - 11:30',
    // 'LT 1'
    ),

  Course(
    'CSCI 4311', 
    'Mobile Application Development', 
    3,
    'Tuesday', 
    Icons.phone_iphone,
    // '14:00 - 15:30',
    // 'LR 13'
    ),

  Course(
    'INFO 4304', 
    'ICT and Islam', 
    3,
    'Wednesday', 
    Icons.mosque,
    // '15:30 - 17:00',
    // 'LT 1'
    ),

  Course(
    'INFO 4303', 
    'Technopreneurship', 
    3,
    'Thursday', 
    Icons.cases_rounded,
    // '10:00 - 11:30',
    // 'LT 1'
    ),

  Course(
    'CSCI 4402', 
    'Final Year Project II', 
    3,
    'Friday', 
    Icons.summarize,
    // '8:00 - 10:00',
    // 'MPH KICT'
    ),
];