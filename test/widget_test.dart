import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';
import 'package:campus_buddy_kict/screens/courses_screen.dart';
import 'package:campus_buddy_kict/screens/profile_screen.dart';

void main() {
  testWidgets('Courses list, grid toggle and day filter', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CoursesScreen()));

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

  testWidgets('Star and live totals', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CoursesScreen()));
    expect(find.textContaining('7 courses · 20 credit hours'), findsOneWidget);
    expect(find.textContaining('Enrolled: 0 CH'), findsOneWidget);

    // star the first row
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('Add course popup validates and adds', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CoursesScreen()));

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

  testWidgets('Shell tabs keep state', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    expect(find.text('Home — coming in Week 7'), findsNothing);
    expect(find.text('Prayer times'), findsOneWidget);

    // go to Courses, star a course
    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();

    // Home and back: star still there
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsOneWidget);

    // Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('My Profile'), findsOneWidget);
  });

  testWidgets('Detail page removes a course', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CoursesScreen()));

    await tester.tap(find.text('CSCI 4311'));
    await tester.pumpAndSettle();
    expect(find.text('Mobile Application Development'), findsOneWidget);
    expect(find.text('3 credit hours · Monday'), findsOneWidget);

    // back button = nothing removed
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('CSCI 4311'), findsOneWidget);

    // remove
    await tester.tap(find.text('CSCI 4311'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove this course'));
    await tester.pumpAndSettle();
    expect(find.text('CSCI 4311'), findsNothing);
    expect(find.textContaining('6 courses · 17 credit hours'), findsOneWidget);
  });

  testWidgets('Home cards, About and clear favourites', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    // About from the app bar icon, closed with Close
    await tester.tap(find.byIcon(Icons.info_outline).first);
    await tester.pumpAndSettle();
    expect(find.text('1.0.0 · Week 6'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // About card
    await tester.tap(find.text('About Campus Buddy KICT'));
    await tester.pumpAndSettle();
    expect(find.text('1.0.0 · Week 6'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // stubs
    await tester.tap(find.text('Prayer times'));
    await tester.pumpAndSettle();
    expect(find.text('Prayer times — coming in Week 8'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Campus links'));
    await tester.pumpAndSettle();
    expect(find.text('Campus links — coming in Week 7'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // clear favourites from Home: confirm screen, but Home can't reach them
    await tester.tap(find.text('Clear all favourites'));
    await tester.pumpAndSettle();
    expect(find.text('Are you sure?'), findsOneWidget);
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(find.textContaining("Home can't reach"), findsOneWidget);
  });

  testWidgets('Clear favourites from Courses tab', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CoursesScreen()));
    await tester.tap(find.byIcon(Icons.star_border).first);
    await tester.pump();
    expect(find.byIcon(Icons.star), findsOneWidget);

    // No keeps them
    await tester.tap(find.byIcon(Icons.star_half));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsOneWidget);

    // Yes clears them
    await tester.tap(find.byIcon(Icons.star_half));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.star), findsNothing);
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
