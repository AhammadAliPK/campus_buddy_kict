
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_buddy_kict/shell_screen.dart';

void main() {
  testWidgets('Campus Buddy KICT navigation test',
      (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(
      const MaterialApp(
        home: ShellScreen(),
      ),
    );

    // Verify that the navigation tabs exist.
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Courses'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });
}
