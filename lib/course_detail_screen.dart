import 'package:flutter/material.dart';
import 'models/course.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Icon(
                      course.icon,
                      size: 80,
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      course.code,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.name,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Divider(),

              // Day
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Day'),
                subtitle: Text(course.day),
              ),

              // Time
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Time'),
                subtitle: Text(course.time),
              ),

              // Venue
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Venue'),
                subtitle: Text(course.venue),
              ),

              // Instructor
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Instructor'),
                subtitle: Text(course.instructor ?? 'Not assigned'),
              ),

              // Credit Hours
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Credit Hours'),
                subtitle: Text('${course.creditHours}'),
              ),

              const Divider(),

              // Favourite Status
              ListTile(
                leading: Icon(
                  course.isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                title: const Text('Favourite'),
                subtitle: Text(
                  course.isFavorite ? 'Yes' : 'No',
                ),
              ),

              // Enrollment Status
              ListTile(
                leading: Icon(
                  course.enrolled
                      ? Icons.check_circle
                      : Icons.cancel_outlined,
                  color: course.enrolled ? Colors.green : Colors.grey,
                ),
                title: const Text('Enrollment Status'),
                subtitle: Text(
                  course.enrolled ? 'Enrolled' : 'Not Enrolled',
                ),
              ),

              const SizedBox(height: 24),

              // Back Button - Return Data
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      'Course details viewed',
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Courses'),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}