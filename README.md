
# voice_formly

`voice_formly` is a customizable Flutter form field widget that adds **built-in validation** and **speech-to-text input** support. It simplifies voice-powered form handling and allows users to build accessible and modern form experiences faster.



##  Features

- 🎤 Voice input (speech-to-text) for supported fields (text, email, phone, multiline, etc.)
- 🛡️ Built-in smart validation for common fields (email, number, phone)
- 🧠 Custom validation support
- 🧾 Multiple field types: text, email, password, phone, date, multiline, number
- 🎨 Easily configurable with styling, hints, borders, icons
- 📆 Integrated date picker for date fields




##  Screenshots
<table>
  <tr>
    <th style="text-align:center;">Validation Error</th>
    <th style="text-align:center;">Voice Input in Action</th>
  </tr>
  <tr>
    <td align="center">
      <img src="assets/form_validation.jpg" width="200"/>
    </td>
    <td align="center">
      <img src="assets/demo.gif" width="200"/>
    </td>
  </tr>
</table>




## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  voice_formly: ^0.0.3  
````

Import it in your Dart file:

```dart
import 'package:voice_formly/voice_formly.dart';
```



## 🧪 Usage Example

> ✅ **Note:** To enable voice input, you **must implement** the `onMicTap` callback. Without it, the field won’t respond to microphone input.

```dart
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
      home: const VoiceFormExample(),
    );
  }
}

class VoiceFormExample extends StatefulWidget {
  const VoiceFormExample({super.key});

  @override
  State<VoiceFormExample> createState() => _VoiceFormExampleState();
}

class _VoiceFormExampleState extends State<VoiceFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _activeMicFieldId;

  void _handleMicTap(String fieldId) {
    setState(() {
      _activeMicFieldId = fieldId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VoiceFormly Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              VoiceFormField(
                controller: _emailController,
                fieldId: 'email',
                label: 'Email Address',
                hint: 'Tap mic and speak your email',
                fieldType: FormFieldType.email,
                enableVoice: true,
                onMicTap: _handleMicTap,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form submitted')),
                    );
                  }
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
```

##  Built-in Validators

You can use built-in validators by setting the `fieldType`. For example:

```dart
fieldType: FormFieldType.email // Automatically validates email format
```

Or you can override it with your own:

```dart
validator: (value) {
  if (value == null || value.length < 6) return 'Minimum 6 characters required';
  return null;
}
```

## 🧾 VoiceFormField Parameters

| Parameter              | Type                                      | Description                                                                 |
|------------------------|-------------------------------------------|-----------------------------------------------------------------------------|
| `fieldId`              | `String`                                  | Unique identifier for the field (used with callbacks).                     |
| `onMicTap`             | `Function(String fieldId)?`               | Required if enableVoice is true. Callback when mic icon is tapped. tapped.                             |
| `controller`           | `TextEditingController`                   | Controller for managing the text input.                                    |
| `hint`                 | `String?`                                  | Placeholder or hint shown inside the field.                                |
| `height`               | `int?`                                     | Custom height of the field in logical pixels.                              |
| `width`                | `int?`                                     | Custom width of the field in logical pixels.                               |
| `fontSize`             | `int`                                      | Font size of the input text.                                               |
| `maxLines`             | `int?`                                     | Maximum number of lines (useful for multiline fields).                     |
| `minLines`             | `int?`                                     | Minimum number of lines.                                                   |
| `errorMaxLines`        | `int?`                                     | Maximum number of lines for the error message.                             |
| `keyboardType`         | `TextInputType?`                           | Keyboard input type (text, email, number, etc.).                           |
| `borderColor`          | `Color`                                    | Border color when the field is focused.                                    |
| `label`                | `String?`                                  | Label shown above the field.                                               |
| `enableVoice`          | `bool`                                     | Whether to enable voice input functionality.                               |
| `suffixIconButton`     | `IconButton?`                              | Custom suffix icon at the end of the field.                                |
| `autofocus`            | `bool?`                                    | Whether to autofocus the field on load.                                    |
| `autocorrect`          | `bool?`                                    | Whether to enable autocorrect for the input.                               |
| `textInputAction`      | `TextInputAction?`                         | The action button on the keyboard (e.g., done, next).                      |
| `autoValidateMode`     | `AutovalidateMode?`                        | Controls when to auto-validate the field (e.g., always, onUserInteraction).|
| `padding`              | `EdgeInsets?`                              | Custom padding inside the form field.                                      |
| `validator`            | `String? Function(String?)?`              | Custom validation logic.                                                   |
| `fieldType`            | `FormFieldType`                            | Determines behavior (e.g., text, email, password, date).                   |
| `enabledBorder`        | `InputBorder?`                             | Border style when field is enabled.                                        |
| `border`               | `InputBorder?`                             | Default border style.                                                      |
| `focusedErrorBorder`   | `InputBorder?`                             | Border style when field has focus and an error.                            |
| `focusedBorder`        | `InputBorder?`                             | Border style when field is focused.                                        |
| `errorBorder`          | `InputBorder?`                             | Border style when validation fails.                                        |
| `disabledBorder`       | `InputBorder?`                             | Border style when the field is disabled.                                   |

## 📄 License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.
