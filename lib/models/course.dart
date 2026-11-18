import 'package:flutter/material.dart';

class Course {
  const Course({
    required this.code,
    required this.title,
    required this.day,
    required this.time,
    required this.room,
    required this.credits,
    required this.color,
    this.section = '1',
    this.status = 'Registered',
    this.lecturer = 'To be confirmed',
    this.description =
        'Course information can be updated from the course editor.',
    this.isFavourite = false,
    this.isEnrolled = true,
    this.note = '',
  });

  final String code;
  final String title;
  final String day;
  final String time;
  final String room;
  final int credits;
  final Color color;
  final String section;
  final String status;
  final String lecturer;
  final String description;
  final bool isFavourite;
  final bool isEnrolled;
  final String note;

  Course copyWith({
    String? code,
    String? title,
    String? day,
    String? time,
    String? room,
    int? credits,
    Color? color,
    String? section,
    String? status,
    String? lecturer,
    String? description,
    bool? isFavourite,
    bool? isEnrolled,
    String? note,
  }) {
    return Course(
      code: code ?? this.code,
      title: title ?? this.title,
      day: day ?? this.day,
      time: time ?? this.time,
      room: room ?? this.room,
      credits: credits ?? this.credits,
      color: color ?? this.color,
      section: section ?? this.section,
      status: status ?? this.status,
      lecturer: lecturer ?? this.lecturer,
      description: description ?? this.description,
      isFavourite: isFavourite ?? this.isFavourite,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      note: note ?? this.note,
    );
  }
}
