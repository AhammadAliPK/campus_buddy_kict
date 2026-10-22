import 'package:flutter_test/flutter_test.dart';
import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('App shows the profile screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    expect(find.text('My Profile'), findsOneWidget);
  });
}