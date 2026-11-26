import 'package:campus_buddy_kict/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home navigation opens About and app destinations', (
    tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.pumpAndSettle();

    expect(find.text('Campus Buddy KICT'), findsOneWidget);
    expect(find.text('Prayer times'), findsOneWidget);
    expect(find.text('Campus links'), findsOneWidget);
    expect(find.byTooltip('Share Campus Buddy KICT'), findsOneWidget);

    await tester.tap(find.byTooltip('About'));
    await tester.pumpAndSettle();
    expect(find.text('Developed by simo'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Prayer times'));
    await tester.pumpAndSettle();
    expect(find.text('Prayer times — coming soon'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Campus links'));
    await tester.pumpAndSettle();
    expect(find.text('IIUM portal'), findsOneWidget);
    expect(find.text('IIUM website'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('KICT'), findsOneWidget);
    expect(find.text('Campus map'), findsOneWidget);
    expect(find.text('Call university hotline'), findsOneWidget);
    expect(find.text('Email academic advisor'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Share Campus Buddy KICT'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Share Campus Buddy KICT'), findsOneWidget);

    await tester.ensureVisible(find.text('IIUM website'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('IIUM website'));
    await tester.pumpAndSettle();
  });

  testWidgets('course detail removes a course and navigation preserves state', (
    tester,
  ) async {
    await tester.pumpWidget(const CampusBuddyKictApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();
    expect(
      find.text('6 courses · 19 credit hours\nEnrolled: 10 CH'),
      findsOneWidget,
    );

    await tester.tap(find.text('CSCI 4334'));
    await tester.pumpAndSettle();
    expect(find.text('Network System and Administration'), findsOneWidget);
    await tester.tap(find.text('Remove this course'));
    await tester.pumpAndSettle();

    expect(
      find.text('5 courses · 16 credit hours\nEnrolled: 10 CH'),
      findsOneWidget,
    );

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();
    expect(
      find.text('5 courses · 16 credit hours\nEnrolled: 10 CH'),
      findsOneWidget,
    );
    expect(find.text('CSCI 4334'), findsNothing);
  });
}
