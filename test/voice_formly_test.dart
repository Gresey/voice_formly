import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_formly/voice_formly.dart';

void main() {
  group('VoiceFormField Widget Tests', () {
    testWidgets('renders with label and hint', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoiceFormField(
              controller: controller,
              fieldId: 'test_field',
              label: 'Name',
              hint: 'Enter your name',
              fieldType: FormFieldType.text,
            ),
          ),
        ),
      );

      // Check for label and hint text
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);
    });

    testWidgets('accepts text input', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoiceFormField(
              controller: controller,
              fieldId: 'text_field',
              label: 'Text Field',
              fieldType: FormFieldType.text,
            ),
          ),
        ),
      );

      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'Hello Voice Formly');
      expect(controller.text, 'Hello Voice Formly');
    });

    testWidgets('validates empty email as invalid', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: VoiceFormField(
                controller: controller,
                fieldId: 'email_field',
                label: 'Email',
                fieldType: FormFieldType.email,
              ),
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
    });

    testWidgets('validates correct email as valid', (WidgetTester tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController(text: 'test@example.com');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: VoiceFormField(
                controller: controller,
                fieldId: 'email_field',
                label: 'Email',
                fieldType: FormFieldType.email,
              ),
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isTrue);
    });
  });
}
