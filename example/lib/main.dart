import 'package:flutter/material.dart';
import 'package:voice_formly/voice_formly.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers for each field
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _date = TextEditingController();

  String? _activeMicFieldId;

  void _handleMicTap(String fieldId) {
    setState(() {
      _activeMicFieldId = fieldId;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Center(child: Text("Form"))),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// Email field
                  VoiceFormField(
                    controller: _email,
                    fieldId: 'email',
                    onMicTap: _handleMicTap,
                    fieldType: FormFieldType.email,
                    enableVoice: true,
                    label: 'Email',
                  ),

                  /// Password field
                  VoiceFormField(
                    controller: _password,
                    validator: (value) {
                      // custom validator for password field
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    fieldId: 'password',
                    onMicTap: _handleMicTap,
                    fieldType: FormFieldType.password,
                    label: 'Password',
                  ),

                  /// Date picker field
                  VoiceFormField(
                    controller: _date,
                    fieldId: 'date',
                    fieldType: FormFieldType.date,
                    label: 'Date of Birth',
                  ),

                  /// Submit Button
                  Container(
                    width: 320,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Form submitted successfully!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please fix the errors in the form.')),
                          );
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
