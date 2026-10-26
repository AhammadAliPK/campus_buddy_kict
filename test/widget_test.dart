import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Courses screen shows the summary card', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Courses'), findsOneWidget);
    expect(find.text('6 courses · 16.5 credit hours'), findsOneWidget);
  });
}
