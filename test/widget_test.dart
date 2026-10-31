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
    await tester.enterText(find.byType(TextField).at(1), 'A temporary bio');
    await tester.enterText(find.byType(TextField).last, '123456789');
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'Guest Student',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).last).controller!.text,
      '202300000',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).last).keyboardType,
      TextInputType.number,
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Guest Student'), findsOneWidget);
    expect(find.text('202300000'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '   ');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Guest Student'), findsOneWidget);
  });
}
