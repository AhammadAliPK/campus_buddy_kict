import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';
import 'package:campus_buddy_kict/screens/links_screen.dart';
import 'package:campus_buddy_kict/screens/profile_screen.dart';

// Opens the app on the Courses tab.
Future<void> openCourses(WidgetTester tester) async {
  await tester.pumpWidget(const CampusBuddyKictApp());
  await tester.tap(find.text('Courses'));
  await tester.pumpAndSettle();
}

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
  testWidgets('Shell: four tabs switch screens and keep state', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    expect(find.text('Campus Buddy KICT'), findsOneWidget); // Home
    for (final tab in ['Courses', 'Notes', 'Profile', 'Home']) {
      expect(find.text(tab), findsWidgets);
    }

    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();
    expect(find.byIcon(Icons.star), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsOneWidget); // IndexedStack kept it

    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    expect(find.text('Notes arrive in Week 11'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Guest Student'), findsOneWidget);
  });

  testWidgets('Courses: summary card and list/grid toggle', (tester) async {
    await openCourses(tester);
    expect(
      find.text('4 courses · 13 credit hours\nEnrolled: 0 CH'),
      findsOneWidget,
    );
    await tester.tap(find.byTooltip('Grid view'));
    await tester.pump();
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('Enroll by tapping the round icon', (tester) async {
    await openCourses(tester);
    await tester.tap(find.byIcon(Icons.school)); // CSCI 4402's icon
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.textContaining('Enrolled: 4 CH'), findsOneWidget);
  });

  testWidgets('Detail page: remove pops true and the row goes', (tester) async {
    await openCourses(tester);
    await tester.tap(find.text('CSCI 4402'));
    await tester.pumpAndSettle();
    expect(find.text('Final Year Project II'), findsOneWidget);
    expect(find.text('4 credit hours · Friday'), findsOneWidget);

    await tester.tap(find.text('Remove this course'));
    await tester.pumpAndSettle();
    expect(find.text('CSCI 4402'), findsNothing);
    expect(find.textContaining('3 courses · 9 credit hours'), findsOneWidget);
  });

  testWidgets('Detail page: back button changes nothing', (tester) async {
    await openCourses(tester);
    await tester.tap(find.text('CSCI 4402'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('CSCI 4402'), findsOneWidget);
    expect(find.textContaining('4 courses'), findsOneWidget);
  });

  testWidgets('Edit: save replaces the row and keeps its star', (tester) async {
    await openCourses(tester);
    // Star CSCI 4320 (second row) first.
    await tester.tap(find.byIcon(Icons.star_border).at(1));
    await tester.pump();

    await tester.tap(find.text('CSCI 4320'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Course name'),
      'Software Testing & QA',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Software Testing & QA'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('Edit: system back from the form changes nothing', (
    tester,
  ) async {
    await openCourses(tester);
    await tester.tap(find.text('CSCI 4320'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Course name'),
      'Should not be saved',
    );
    await tester.pageBack(); // leave the edit form
    await tester.pumpAndSettle();
    await tester.pageBack(); // leave the detail page
    await tester.pumpAndSettle();
    expect(find.textContaining('Should not be saved'), findsNothing);
    expect(find.textContaining('Software Testing'), findsOneWidget);
  });

  testWidgets('Edit: duplicate code is refused', (tester) async {
    await openCourses(tester);
    await tester.tap(find.text('CSCI 4320'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Code (e.g. CSCI 4311)'),
      'CSCI 4311',
    );
    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(find.text('Already added'), findsOneWidget);
  });

  testWidgets('Clear favourites asks on a full screen first', (tester) async {
    await openCourses(tester);
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();
    expect(find.byIcon(Icons.star), findsNWidgets(2));

    await tester.tap(find.byTooltip('Clear all favourites'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsNWidgets(2));

    await tester.tap(find.byTooltip('Clear all favourites'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsNothing);
  });

  testWidgets('Home: About by name, both cards open pages', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.tap(find.byTooltip('About'));
    await tester.pumpAndSettle();
    expect(find.text('1.0.0 · Week 6'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Campus links'));
    await tester.pumpAndSettle();
    expect(find.text('IIUM website'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Prayer times'));
    await tester.pumpAndSettle();
    expect(find.text('Prayer times arrive in Week 8'), findsOneWidget);
  });

  testWidgets('Links page: all rows and the in-app switch', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    expect(find.byTooltip('Share Campus Buddy KICT'), findsOneWidget);
    await tester.tap(find.text('Campus links'));
    await tester.pumpAndSettle();
    for (final t in [
      'IIUM portal',
      'IIUM website',
      'Library',
      'KICT',
      'CELPAD',
    ]) {
      expect(find.text(t), findsOneWidget);
    }
    expect(find.text('Websites open in your browser'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(find.text('Websites open inside Campus Buddy'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Share Campus Buddy KICT'), 200);
    for (final t in [
      'Campus map: Gombak',
      'Campus map: Kuantan',
      'Call university hotline',
      'Email academic advisor',
      'Share Campus Buddy KICT',
    ]) {
      expect(find.text(t), findsOneWidget);
    }
  });

  test('Advisor mail link is URL-encoded and has my matric', () {
    expect(advisorMailUri.contains(' '), isFalse);
    expect(advisorMailUri, contains('2311687'));
    final body = Uri.parse(advisorMailUri).queryParameters['body']!;
    expect(body, contains('matric 2311687'));
  });

  testWidgets('Add course: validation, new row, duplicate guard', (
    tester,
  ) async {
    await openCourses(tester);
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
    await openCourses(tester);
    await tester.longPress(find.text('CSCI 4402'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(find.text('CSCI 4402'), findsNothing);
  });

  testWidgets('Favourites-only chip filters the list', (tester) async {
    await openCourses(tester);
    await tester.tap(find.byIcon(Icons.star_border).at(1)); // CSCI 4320
    await tester.pump();
    await tester.tap(find.byType(FilterChip));
    await tester.pump();
    expect(find.text('CSCI 4320'), findsOneWidget);
    expect(find.text('CSCI 4311'), findsNothing);
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
