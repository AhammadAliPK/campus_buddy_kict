
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Campus Buddy KICT launches successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.pumpAndSettle();

    // Verify that the main app loads.
    expect(find.text('Courses'), findsWidgets);
    expect(find.text('Profile'), findsOneWidget);
  });
}
