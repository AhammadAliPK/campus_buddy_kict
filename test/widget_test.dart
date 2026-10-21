import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Profile edit, empty nickname and reset', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('ansimrn_'), findsOneWidget);
    expect(find.textContaining('Year 4'), findsOneWidget);
    expect(find.text('2317243'), findsOneWidget);

    // edit and save
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), 'Anas');
    await tester.enterText(
        find.widgetWithText(TextField, 'Matric number'), '2312345');
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Anas'), findsOneWidget);
    expect(find.text('2312345'), findsOneWidget);

    // empty nickname keeps 'Guest Student'
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), '   ');
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Guest Student'), findsOneWidget);

    // reset puts everything back
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.tap(find.text('Reset'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('ansimrn_'), findsOneWidget);
    expect(find.text('2317243'), findsOneWidget);
  });
}
