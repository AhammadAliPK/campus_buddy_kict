import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Courses list shows summary and toggles to grid',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Courses'), findsOneWidget);
    expect(find.text('5 courses · 15 credit hours'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.byIcon(Icons.list));
    await tester.pump();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byIcon(Icons.grid_on), findsOneWidget);
  });
}
