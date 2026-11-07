import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';
import 'package:campus_buddy_kict/screens/profile_screen.dart';

void main() {
  testWidgets('Courses list, grid toggle and day filter', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Courses'), findsOneWidget);
    expect(find.text('CSCI 4311'), findsOneWidget);
    expect(find.text('CSCI 3211'), findsOneWidget);

    // filter by Tuesday
    await tester.tap(find.widgetWithText(ChoiceChip, 'Tuesday'));
    await tester.pump();
    expect(find.text('CSCI 4311'), findsNothing);
    expect(find.text('CSCI 3211'), findsOneWidget);

    // switch to grid
    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pump();
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('Star, enroll and live totals', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    expect(find.textContaining('7 courses · 20 credit hours'), findsOneWidget);
    expect(find.textContaining('Enrolled: 0 CH'), findsOneWidget);

    // star the first row
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();
    expect(find.byIcon(Icons.star), findsOneWidget);

    // tap a row -> enrolled, green tick, total changes
    await tester.tap(find.text('CSCI 4311'));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.textContaining('Enrolled: 3 CH'), findsOneWidget);

    // filtered view still toggles the right course
    await tester.tap(find.widgetWithText(ChoiceChip, 'Tuesday'));
    await tester.pump();
    await tester.tap(find.text('CSCI 3211'));
    await tester.pump();
    expect(find.textContaining('Enrolled: 6 CH'), findsOneWidget);
  });

  testWidgets('Add course popup validates and adds', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Add a course'), findsOneWidget);

    // empty form -> errors, popup stays
    await tester.tap(find.text('Add'));
    await tester.pump();
    expect(find.text('Code is required'), findsOneWidget);
    expect(find.text('Name is required'), findsOneWidget);

    // bad format
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Code (e.g. CSCI 4311)'), 'hello');
    await tester.tap(find.text('Add'));
    await tester.pump();
    expect(find.text('Format: 4 letters + 4 digits'), findsOneWidget);

    // duplicate guard
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Code (e.g. CSCI 4311)'),
        'CSCI4311');
    await tester.tap(find.text('Add'));
    await tester.pump();
    expect(find.text('Already added'), findsOneWidget);

    // valid course -> popup closes, list and summary grow
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Code (e.g. CSCI 4311)'),
        'CSCI 4999');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Course name'), 'Test Course');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('Add a course'), findsNothing);
    expect(find.textContaining('8 courses · 23 credit hours'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('CSCI 4999'), 100,
        scrollable: find.byType(Scrollable).last);
    expect(find.text('CSCI 4999'), findsOneWidget);
  });

  testWidgets('Profile edit, empty nickname and reset', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

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
