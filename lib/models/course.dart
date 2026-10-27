import 'package:flutter/material.dart';

class Course {
  final String code; // 'CSCI 4311'
  final String name; // 'Mobile Application Development'
  final int creditHours; // 3
  final IconData icon; // Icons.phone_iphone
  final String day; // 'Monday'

  const Course(this.code, this.name, this.creditHours, this.icon, this.day);
}
