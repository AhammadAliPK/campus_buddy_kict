import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Profile edit, empty-nickname fallback and reset', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    expect(find.text('Guest Student'), findsOneWidget);

    // Edit nickname and save.
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), 'Ali');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();
    expect(find.text('Ali'), findsOneWidget);

    // Spaces-only nickname falls back to the default.
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), '   ');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();
    expect(find.text('Guest Student'), findsOneWidget);

    // Reset restores the matric number.
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

  testWidgets('Courses: list/grid toggle and day filter', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.tap(find.byIcon(Icons.menu_book));
    await tester.pumpAndSettle();
    expect(find.text('CSCI 4311'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);

    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pump();
    expect(find.byType(GridView), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Friday'));
    await tester.pump();
    expect(find.text('CSCI 4311'), findsNothing);
    expect(find.text('CSCI 4402'), findsOneWidget);

    await tester.tap(find.text('CSCI 4402'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
