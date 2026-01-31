// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cardbenefits/main.dart';

void main() {
  testWidgets('Card Benefits App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CardBenefitsApp());

    // Verify that the app loads with the correct title.
    expect(find.text('Card Benefit Assistant'), findsOneWidget);

    // Verify that the main UI elements are present.
    expect(find.text('Discover Your Benefits'), findsOneWidget);
    expect(find.text('Card Number'), findsOneWidget);
    expect(find.text('User Type'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Preferred Language'), findsOneWidget);

    // Verify the analyze button is present.
    expect(find.text('Analyze Benefits'), findsOneWidget);

    // Verify language selector options are present.
    expect(find.text('English'), findsOneWidget);
    expect(find.text('தமிழ்'), findsOneWidget);
  });

  testWidgets('Form validation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CardBenefitsApp());

    // Try to submit without filling the form.
    await tester.tap(find.text('Analyze Benefits'));
    await tester.pumpAndSettle();

    // Verify validation messages appear.
    expect(find.text('Please enter card number'), findsOneWidget);
    expect(find.text('Please enter your location'), findsOneWidget);
  });

  testWidgets('Navigation to disclaimer test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CardBenefitsApp());

    // Tap the info icon to navigate to disclaimer.
    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    // Verify that we navigated to the disclaimer page.
    expect(find.text('About & Disclaimer'), findsOneWidget);
    expect(find.text('Important Information'), findsOneWidget);
  });
}
