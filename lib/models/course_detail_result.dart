
import 'package:campus_buddy_kict/models/course.dart';

class CourseDetailResult {
  final Course? updatedCourse;
  final bool removed;

  const CourseDetailResult({
    this.updatedCourse,
    this.removed = false,
  });
}
