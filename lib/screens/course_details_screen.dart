import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course});

    final Course course;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(course.code),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children:[
                Icon(course.icon, size: 48,
                color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(course.name, style: Theme.of(context).textTheme.headlineSmall),
                ),
              ]),
              const SizedBox(height: 16),
              Text('${course.creditHours} credit hours | ${course.day}'), 
              const SizedBox(height: 16),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.delete_outlined),
                  label: const Text('Remove This Course'),
                ),
              ),
            ],
          ),
        ),
      );
    }
}