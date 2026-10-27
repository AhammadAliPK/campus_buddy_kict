import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';
import 'package:campus_buddy_kict/data/courses.dart';

void main() {
  testWidgets('Courses list, grid toggle and day filter', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Courses'), findsOneWidget);
    expect(find.textContaining('${sampleCourses.length} courses'),
        findsOneWidget);
    expect(find.byType(ListView), findsWidgets);

    // tap a row -> SnackBar
    await tester.tap(find.text(sampleCourses.first.code));
    await tester.pump();
    expect(find.text('${sampleCourses.first.code} tapped'), findsOneWidget);

    // switch to grid
    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pump();
    expect(find.byType(GridView), findsOneWidget);

    // filter by Monday
    await tester.tap(find.widgetWithText(ChoiceChip, 'Monday'));
    await tester.pump();
    final monday = sampleCourses.where((c) => c.day == 'Monday').length;
    expect(find.textContaining('$monday courses'), findsOneWidget);
  });

  testWidgets('Profile edit, empty nickname and reset', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

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
