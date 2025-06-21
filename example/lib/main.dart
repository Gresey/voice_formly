import 'package:flutter/material.dart';
import 'package:voice_formly/voice_formly.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('VoiceFormly Example')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: VoiceFormField(
            controller: TextEditingController(),
            fieldType: FormFieldType.text,
            fieldId: 'exampleField',
            label: 'Enter your name',
            hint: 'Tap mic and speak',
            enableVoice: true,
            borderColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
