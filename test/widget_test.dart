import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('profile can be reset and saved', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Profile'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Campus Buddy');
    await tester.enterText(find.byType(TextField).last, 'A temporary bio');
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'Guest Student',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).last).controller!.text,
      'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.',
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Guest Student'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });
}
