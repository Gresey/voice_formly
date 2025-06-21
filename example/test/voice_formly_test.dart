import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voice_formly_example/main.dart';

void main() {
  testWidgets('VoiceFormField  text field appear', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Check if there's a TextField in the widget tree
    expect(find.byType(TextField), findsOneWidget);
  });
  testWidgets('VoiceFormField accepts input', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Enter some text
    await tester.enterText(find.byType(TextField), 'John Doe');

    // Verify entered text
    expect(find.text('John Doe'), findsOneWidget);
  });
}
