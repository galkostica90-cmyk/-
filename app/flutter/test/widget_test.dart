import 'package:flutter_test/flutter_test.dart';
import 'package:attendance_app/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('app shows check-in button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Check in'), findsOneWidget);
  });
}
