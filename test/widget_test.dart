import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Profile edit, empty nickname and reset', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.tap(find.text('Profile'));
    await tester.pump();

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Nisrina'), findsOneWidget);
    expect(find.text('2314188'), findsOneWidget);

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

    // Empty nickname falls back to the default nickname.
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), '   ');
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Nisrina'), findsOneWidget);

    // Reset restores the defaults.
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.tap(find.text('Reset'));
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Nisrina'), findsOneWidget);
    expect(find.text('2314188'), findsOneWidget);
  });

  testWidgets('Star survives a tab switch', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.tap(find.text('Courses'));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();
    expect(find.byIcon(Icons.star), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pump();
    await tester.tap(find.text('Courses'));
    await tester.pump();
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('Detail page removes the tapped course', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.tap(find.text('Courses'));
    await tester.pump();
    expect(find.text('5 courses · 13.5 credit hours'), findsOneWidget);

    await tester.tap(find.text('CSCI 4311'));
    await tester.pumpAndSettle();
    expect(find.text('Mobile Application Development'), findsOneWidget);

    await tester.tap(find.text('Remove this course'));
    await tester.pumpAndSettle();
    expect(find.text('CSCI 4311'), findsNothing);
    expect(find.text('4 courses · 10.5 credit hours'), findsOneWidget);
  });

  testWidgets('Edit saves, back cancels', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.tap(find.text('Courses'));
    await tester.pump();

    // Back from the edit screen changes nothing.
    await tester.tap(find.text('CSCI 4311'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Course name'), 'Changed');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.textContaining('Changed'), findsNothing);

    // Save replaces the row.
    await tester.tap(find.text('CSCI 4311'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Course name'), 'Flutter Apps');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Flutter Apps'), findsOneWidget);
  });

  testWidgets('About opens from Home and closes', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.tap(find.byIcon(Icons.info_outline).first);
    await tester.pumpAndSettle();
    expect(find.text('1.0.0 · Week 6'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Prayer times'), findsOneWidget);
  });
}
