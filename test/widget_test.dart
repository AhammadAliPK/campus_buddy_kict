
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Campus Buddy KICT loads successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    await tester.pumpAndSettle();

    expect(find.text('My Courses'), findsOneWidget);
  });
}
