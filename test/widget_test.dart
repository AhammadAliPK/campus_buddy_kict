// Smoke test for the Week 4 courses screen.
//
// Run with: flutter test

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/data/courses.dart';
import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Courses list shows the summary card and the course codes',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    final totalCh =
        sampleCourses.fold<int>(0, (sum, c) => sum + c.creditHours);
    expect(
      find.text('${sampleCourses.length} courses · $totalCh credit hours'),
      findsOneWidget,
    );
    expect(find.text(sampleCourses.first.code), findsOneWidget);

    // The grid toggle flips the icon and keeps the data on screen.
    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.grid_on), findsOneWidget);
    expect(find.text(sampleCourses.first.code), findsOneWidget);
  });

  testWidgets('Day filter keeps only that day\'s courses',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    final monday = sampleCourses.where((c) => c.day == 'Monday').toList();
    final tuesday = sampleCourses.firstWhere((c) => c.day == 'Tuesday');

    await tester.tap(find.widgetWithText(FilterChip, 'Monday'));
    await tester.pumpAndSettle();

    expect(find.text(monday.first.code), findsOneWidget);
    expect(find.text(tuesday.code), findsNothing);
    expect(find.text('${monday.length} courses · 3 credit hours'), findsOneWidget);
  });
}
