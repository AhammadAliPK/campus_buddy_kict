import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

final Map<String, int> dayOrder = {
  'Monday': 1,
  'Tuesday': 2,
  'Wednesday': 3,
  'Thursday': 4,
  'Friday': 5,
  'Saturday': 6,
  'Sunday': 7,
};

const List<Course> sampleCourses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    'Tuesday',
    Icons.phone_iphone,
    '14:00–15:20',
    'ICT LR 13 LVL 2D',
    'POYILIKANDIYIL AHAMMAD ALI',
  ),
  Course(
    'CSCI 4320',
    'Software Testing',
    3,
    'Tuesday',
    Icons.bug_report,
    '11:30–12:50',
    'TL-E5-01',
    'NORMI SHAM BT. AWANG ABU BAKAR',
  ),
  Course(
    'CSCI 4340',
    'Machine Learning',
    3,
    'Thursday',
    Icons.engineering,
    '08:30–09:50',
    'ICT TL 4',
    'AMIR AATIEFF BIN AMIR HUSSIN',
  ),
  Course(
    'CCFA 2010',
    'First Aid Skills',
    1,
    'Wednesday',
    Icons.healing,
    '20:00–22:00',
    'KENMS 3.10',
    'NURUL KHALIESAH BT. ISHAK',
  ),
  Course(
    'CSCI 4402',
    'Final Year Project II',
    3,
    'Friday',
    Icons.assignment,
    '11:30–12:50',
    'ICT LT1 LVL 4D',
    'AHMAD ANWAR BIN ZAINUDDIN',
  ),
];
