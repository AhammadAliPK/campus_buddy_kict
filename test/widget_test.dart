import 'package:campus_buddy_kict/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows six courses and switches between list and grid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.pumpAndSettle();

    expect(find.text('My Courses'), findsOneWidget);
    expect(find.text('6 courses · 0 credit hours'), findsOneWidget);
    expect(find.text('COURSE 1'), findsOneWidget);
    expect(find.text('COURSE 6'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);

    await tester.tap(find.byIcon(Icons.grid_on));
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
  });
}
