import 'package:flutter/material.dart';

import 'data/courses.dart';
import 'models/campus_note.dart';
import 'models/course.dart';

class CampusBuddyState extends ChangeNotifier {
  CampusBuddyState() : _courses = List.of(campusCourses);

  final List<Course> _courses;
  final List<CampusNote> _notes = [
    const CampusNote(
      subject: 'Week 6 review',
      body: 'Remember to review the app shell exercise before the next lab.',
    ),
  ];
  String _nickname = 'Rafiq Hamsyari';
  String _bio = 'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
  String _advisorEmail = '';

  List<Course> get courses => List.unmodifiable(_courses);
  List<CampusNote> get notes => List.unmodifiable(_notes);
  String get nickname => _nickname;
  String get bio => _bio;
  String get advisorEmail => _advisorEmail;

  int get totalCredits => _courses
      .where((course) => course.isEnrolled)
      .fold(0, (total, course) => total + course.credits);

  int get enrolledCourseCount =>
      _courses.where((course) => course.isEnrolled).length;

  int get totalCourseCredits =>
      _courses.fold(0, (total, course) => total + course.credits);

  void updateProfile({required String nickname, required String bio}) {
    _nickname = nickname.trim().isEmpty ? 'Rafiq Hamsyari' : nickname.trim();
    _bio = bio.trim().isEmpty
        ? 'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.'
        : bio.trim();
    notifyListeners();
  }

  void updateAdvisorEmail(String email) {
    _advisorEmail = email.trim();
    notifyListeners();
  }

  void updateCourse(String originalCode, Course updatedCourse) {
    final index = _courses.indexWhere((course) => course.code == originalCode);
    if (index == -1) return;
    _courses[index] = updatedCourse;
    notifyListeners();
  }

  void addCourse(Course course) {
    _courses.add(course);
    notifyListeners();
  }

  void removeCourse(String code) {
    _courses.removeWhere((course) => course.code == code);
    notifyListeners();
  }

  void clearFavourites() {
    for (var index = 0; index < _courses.length; index++) {
      _courses[index] = _courses[index].copyWith(isFavourite: false);
    }
    notifyListeners();
  }

  void addNote({required String subject, required String body}) {
    final trimmedSubject = subject.trim();
    final trimmedBody = body.trim();
    if (trimmedSubject.isEmpty && trimmedBody.isEmpty) return;
    _notes.insert(
      0,
      CampusNote(
        subject: trimmedSubject.isEmpty ? 'Untitled note' : trimmedSubject,
        body: trimmedBody,
      ),
    );
    notifyListeners();
  }

  void updateNoteAt(int index, CampusNote note) {
    if (index < 0 || index >= _notes.length) return;
    _notes[index] = note;
    notifyListeners();
  }

  void removeNoteAt(int index) {
    if (index < 0 || index >= _notes.length) return;
    _notes.removeAt(index);
    notifyListeners();
  }
}
