import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';
import 'package:campus_buddy_kict/profile_screen.dart';

Future<void> addCourse(WidgetTester tester, String code, String name) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Code (e.g. CSCI 4311)'),
    code,
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Course name'),
    name,
  );
  await tester.tap(find.text('Add'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Courses: summary card and list/grid toggle', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    expect(
      find.text('4 courses · 13 credit hours\nEnrolled: 0 CH'),
      findsOneWidget,
    );
    expect(find.byType(ListView), findsOneWidget);
    await tester.tap(find.byIcon(Icons.list));
    await tester.pump();
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('Star and enroll update the screen and totals', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    expect(find.byIcon(Icons.star), findsNothing);
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();
    expect(find.byIcon(Icons.star), findsOneWidget);

    await tester.tap(find.text('CSCI 4402'));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(
      find.text('4 courses · 13 credit hours\nEnrolled: 4 CH'),
      findsOneWidget,
    );
  });

  testWidgets('Add course: validation, new row, duplicate guard', (
    tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add'));
    await tester.pump();
    expect(find.text('Code is required'), findsOneWidget);
    expect(find.text('Name is required'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await addCourse(tester, 'CSCI 4311', 'Duplicate');
    expect(find.text('Already added'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await addCourse(tester, 'CSCI 9999', 'Brand New');
    expect(find.text('CSCI 9999'), findsOneWidget);
    expect(find.textContaining('5 courses'), findsOneWidget);
  });

  testWidgets('Long-press removes a course after confirmation', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.longPress(find.text('CSCI 4402'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('CSCI 4402'), findsOneWidget);

    await tester.longPress(find.text('CSCI 4402'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(find.text('CSCI 4402'), findsNothing);
    expect(find.textContaining('3 courses'), findsOneWidget);
  });

  testWidgets('Favourites-only chip filters the list', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.tap(find.byIcon(Icons.star_border).at(1)); // CSCI 4320
    await tester.pump();
    await tester.tap(find.byType(FilterChip));
    await tester.pump();
    expect(find.text('CSCI 4320'), findsOneWidget);
    expect(find.text('CSCI 4311'), findsNothing);

    // Enroll acts on the right course while filtered.
    await tester.tap(find.text('CSCI 4320'));
    await tester.pump();
    expect(find.textContaining('Enrolled: 3 CH'), findsOneWidget);

    await tester.tap(find.byType(FilterChip));
    await tester.pump();
    expect(find.text('CSCI 4311'), findsOneWidget);
  });

  testWidgets('Profile screen opens from courses', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.text('Guest Student'), findsOneWidget);
  });

  testWidgets('Profile edit, empty-nickname fallback and reset', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), 'Ali');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();
    expect(find.text('Ali'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), '   ');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();
    expect(find.text('Guest Student'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(
      find.widgetWithText(TextField, 'Matric number'),
      '1',
    );
    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(find.text('2311687'), findsOneWidget);
  });
}
