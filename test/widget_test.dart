import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Profile edit, empty nickname and reset', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Guest Student'), findsOneWidget);
    expect(find.text('202300000'), findsOneWidget);

    // Edit and save new values.
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), '  Ali ');
    await tester.enterText(
        find.widgetWithText(TextField, 'Matric number'), '2312345');
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Ali'), findsOneWidget);
    expect(find.text('2312345'), findsOneWidget);

    // Empty nickname falls back to Guest Student.
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), '   ');
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Guest Student'), findsOneWidget);

    // Reset restores the defaults.
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.tap(find.text('Reset'));
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Guest Student'), findsOneWidget);
    expect(find.text('202300000'), findsOneWidget);
  });
}
