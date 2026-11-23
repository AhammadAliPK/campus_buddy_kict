import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  Future<void> openEditor(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
  }

  Future<void> save(WidgetTester tester) async {
    await tester.tap(find.text('Save'));
    await tester.pump();
  }

  testWidgets('shows the default profile with matric number', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Guest Student'), findsOneWidget);
    expect(find.text('202300000'), findsOneWidget);
  });

  testWidgets('saved edits stay on screen', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await openEditor(tester);

    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), ' Imran ');
    await tester.enterText(
        find.widgetWithText(TextField, 'Matric number'), '2318281');
    await save(tester);

    expect(find.text('Imran'), findsOneWidget);
    expect(find.text('2318281'), findsOneWidget);
  });

  testWidgets('empty nickname falls back to Guest Student', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await openEditor(tester);

    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), '   ');
    await save(tester);

    expect(find.text('Guest Student'), findsOneWidget);
  });

  testWidgets('Reset puts everything back', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await openEditor(tester);

    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), 'Imran');
    await tester.tap(find.text('Reset'));
    await save(tester);

    expect(find.text('Guest Student'), findsOneWidget);
    expect(find.text('202300000'), findsOneWidget);
  });
}
