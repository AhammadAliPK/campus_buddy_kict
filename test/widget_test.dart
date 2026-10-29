import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';
import 'package:campus_buddy_kict/profile_screen.dart';

void main() {
  testWidgets('Courses: summary card, list/grid toggle and tap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    expect(find.text('4 courses · 13 credit hours'), findsOneWidget);
    expect(find.text('CSCI 4311'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.byIcon(Icons.list));
    await tester.pump();
    expect(find.byType(GridView), findsOneWidget);

    await tester.tap(find.byIcon(Icons.grid_on));
    await tester.pump();
    await tester.tap(find.text('CSCI 4402'));
    await tester.pump();
    expect(find.text('CSCI 4402 tapped'), findsOneWidget);
  });

  testWidgets('Profile screen opens from courses and edits', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.text('Guest Student'), findsOneWidget);
  });

  testWidgets('Profile edit, empty-nickname fallback and reset', (
    WidgetTester tester,
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
