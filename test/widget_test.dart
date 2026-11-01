import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Courses screen shows the summary card', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Courses'), findsOneWidget);
    expect(find.text('6 courses · 16.5 credit hours'), findsOneWidget);
    expect(find.text('Enrolled: 0 · 0 credit hours'), findsOneWidget);
  });

  testWidgets('Ticking a course updates the enrolled total', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    expect(find.text('Enrolled: 1 · 3 credit hours'), findsOneWidget);
  });

  testWidgets('Starring a course fills the star', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.byIcon(Icons.star), findsNothing);
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();

    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('Add course form rejects empty input, then saves a course',
      (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    await tester.tap(find.text('Add course'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Code is required'), findsOneWidget);
    expect(find.text('Name is required'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Course code'), 'CSCI 4999');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Course name'), 'Demo Course');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Credit hours'), '2');
    await tester.tap(find.text('Day'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mon').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('7 courses · 18.5 credit hours'), findsOneWidget);
  });
}
