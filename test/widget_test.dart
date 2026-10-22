// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Courses screen can switch between list and grid views', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Courses'), findsOneWidget);
    expect(find.text('2 courses · 6 credit hours'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.grid_on));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);

    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNWidgets(2));
  });
}
