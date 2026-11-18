import 'package:flutter_test/flutter_test.dart';

import 'package:campus_buddy_kict/main.dart';

void main() {
  testWidgets('Campus Buddy opens with student details', (tester) async {
    await tester.pumpWidget(const CampusBuddyKictApp());

    expect(find.text('Campus Buddy'), findsOneWidget);
    expect(find.text('Rafiq Hamsyari'), findsOneWidget);
    expect(find.textContaining('2312887'), findsOneWidget);
    expect(find.text('Section 1 · 2312887'), findsOneWidget);
  });
}
