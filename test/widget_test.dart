import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

const _bioText = 'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';

void main() {
  testWidgets('Profile screen shows app bar, nickname, bio and matric', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.pump();

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('Guest Student'), findsOneWidget);
    expect(find.text('2317783'), findsOneWidget);
    expect(find.text(_bioText), findsOneWidget);

    final bio = tester.widget<Text>(find.text(_bioText));
    expect(bio.maxLines, 1);
    expect(bio.overflow, TextOverflow.ellipsis);
  });

  testWidgets('Empty nickname falls back to Guest Student', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();

    await tester.enterText(find.byType(TextField).at(0), '   ');
    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Guest Student'), findsOneWidget);
  });
}
