import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Home shows shortcuts and the Courses tab opens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.pumpAndSettle();

    expect(find.text('Campus Buddy KICT'), findsOneWidget);
    expect(find.text('Prayer times'), findsOneWidget);
    expect(find.text('Campus links'), findsOneWidget);

    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();

    expect(find.text('My Courses'), findsOneWidget);
  });
}
