import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

// TODO: replace the sample rows below with your real timetable.
const List<Course> sampleCourses = [
  Course('CSCI 4320', 'SOFTWARE TESTING', 3, 'Tuesday/Thursday',
      '11:30 – 12:50', 'TL-E5-01', Icons.code, instructor: 'Dr. NORMI SHAM BT. AWANG ABU BAKAR'),
  Course('CSCI 4334', '	NETWORK AND SYSTEMS ADMINISTRATION', 3, 'Tuesday/Thursday',
      '14:00 - 15:30', 'ICT CISCO LAB2', Icons.phone_iphone, instructor: 'Dr. ADAMU ABUBAKAR IBRAHIM'),
  Course('CSCI 4311', 'MOBILE APPLICATION DEVELOPMENT', 3, 'Tuesday/Thursday',
      '15:30 - 16:50', 'ICT LR 13 LEVEL 2D', Icons.phone_iphone, instructor: 'Dr. POYILIKANDIYIL AHAMMAD ALI'),
  Course('CSCI 4402', 'FINAL YEAR PROJECT II', 3, 'Friday',
      '11:30 - 12:50', 'ICT LT 1 LEVEL 4D', Icons.phone_iphone, instructor: 'Dr. AHMAD ANWAR BIN ZAINUDDIN'),
];
