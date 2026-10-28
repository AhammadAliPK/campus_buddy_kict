import 'package:flutter_test/flutter_test.dart';
import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('My Courses screen displays correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('My Courses'), findsOneWidget);
  });
}
