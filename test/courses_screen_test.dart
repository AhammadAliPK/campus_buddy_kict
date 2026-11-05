import 'package:campus_buddy_kict/screens/courses_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('course actions are available in both layouts', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CoursesScreen()));

    expect(find.byTooltip('Add course'), findsOneWidget);
    expect(find.byTooltip('Grid view'), findsOneWidget);

    await tester.tap(find.byTooltip('Add course'));
    await tester.pumpAndSettle();
    expect(find.text('Add a course'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Grid view'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('List view'), findsOneWidget);
    await tester.tap(find.byTooltip('List view'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Grid view'), findsOneWidget);
  });
}
