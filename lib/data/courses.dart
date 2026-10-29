import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    'CSCI 4402',
    'Final Year Project',
    4,
    'Monday',
    Icons.engineering,
    '10:00–12:00',
    'Lab 1',
  ),
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    'Tuesday',
    Icons.phone_iphone,
    '14:00–15:30',
    'LT A',
    instructor: 'Dr. Poyilikandiyil',
  ),
  Course(
    'CSCI 4312',
    'Blockchain and Applications',
    3,
    'Wednesday',
    Icons.lock,
    '11:00–12:30',
    'LT B',
  ),
  Course(
    'CSCI 4332',
    'Digital Evidence Forensics',
    3,
    'Thursday',
    Icons.security,
    '14:00–15:30',
    'Lab 2',
    instructor: 'Dr. Andi',
  ),
  Course(
    'SCSH 3164',
    'Usrah In Action 2',
    1,
    'Thursday',
    Icons.group,
    '16:00–17:00',
    'Room 3',
    instructor: 'Usman Jaffee',
  ),
];
