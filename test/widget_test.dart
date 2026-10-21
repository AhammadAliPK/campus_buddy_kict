import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Profile screen shows nickname', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Umairah'), findsOneWidget);
  });
}
