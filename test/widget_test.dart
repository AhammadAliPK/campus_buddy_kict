import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('App opens on Home, Courses tab shows the list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    expect(find.text('Prayer times'), findsOneWidget);

    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();
    expect(find.text('My Courses'), findsOneWidget);
  });
}
