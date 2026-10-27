import 'package:flutter_test/flutter_test.dart';
import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CampusBuddyKictApp());

    // Verify that the app title loads
    expect(find.text('My Courses'), findsOneWidget);
  });
}