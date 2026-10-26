import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

// Replace these with your real timetable (at least 5 courses).
const List<Course> sampleCourses = [
  Course('INFO 4304', 'ICT and Islam', 3, 'Monday & Wednesday',
      Icons.phone_iphone,  '15:30–16:50', 'ICT LR 13 LEVEL 2D', 'NOOR HASRUL NIZAN BIN MOHAMMAD NOOR'),
  Course('CSCI 4402', 'Final Year Project II', 4, 'Friday', Icons.code, '11:00–12:50', 'ICT LT 1 LEVEL 4D', 'AHMAD ANWAR BIN ZAINUDDIN'),
  Course('CSCI 4341', 'Big Data Analytics', 3, 'Monday & Wednesday',
      Icons.account_tree, '14:00–15:30', 'ICT LR 15 LEVEL 2D', 'SHARYAR WANI'),
  Course('CSCI 4333', 'Cryptography', 3, 'Tuesday & Thursday', Icons.storage, '11:30-12:50', 'ICT LR 14A LEVEL 2D', '	TAKUMI SASE'),
  Course('CSCI 4311', 'Mobile Application Development', 3, 'Tuesday & Thursday', Icons.menu_book, '14:00–15:20', 'ICT LR 13 LEVEL 2D', 'POYILIKANDIYIL AHAMMAD ALI'),
];