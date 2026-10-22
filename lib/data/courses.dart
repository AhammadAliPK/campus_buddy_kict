import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

// TODO: replace HH:MM–HH:MM and 'Venue?' with your real timetable,
// and add the instructor name as the last value where you know it.
const List<Course> sampleCourses = [
  Course(
    'CSCI 4311',
    'Mobile Application Development',
    3,
    'Tuesday',
    '14:00–15:30',
    'LR13',
    Icons.phone_iphone,
  ),
  Course(
    'CSCI 4343',
    'Data Science',
    3,
    'Monday',
    '10:00–11:30',
    'LR14',
    Icons.science,
  ),
  Course(
    'CSCI 4320',
    'Software Testing',
    3,
    'Tuesday',
    '10:00–11:30',
    'LR13A',
    Icons.bug_report,
  ),
  Course(
    'INFO 4303',
    'Technopreneurship',
    3,
    'Tuesday',
    '11:30–13:00',
    'E02',
    Icons.money,
  ),
  Course(
    'CCCK 2010',
    'Cooking Skills 2',
    1,
    'Wednesday',
    '17:00–19:00',
    'Wadi Budi',
    Icons.egg,
  ),
  Course(
    'CSCI 4402',
    'Final Year Project 2',
    4,
    'Friday',
    '10:00–11:30',
    'MPH',
    Icons.book,
  ),
];
