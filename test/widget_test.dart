import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('empty nickname keeps Guest Student', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    expect(find.text('Guest Student'), findsOneWidget);
    expect(find.text('2317391'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), '   ');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    expect(find.text('Guest Student'), findsOneWidget);
  });
}
