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
  testWidgets('Campus Buddy shows the profile screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Guest Student'), findsOneWidget);
    expect(find.text('202300000'), findsOneWidget);
  });
}
