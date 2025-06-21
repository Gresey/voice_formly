import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voice_formly/services/speech_to_text_service.dart';

/// Defines the types of form fields this widget can render.
enum FormFieldType {
  text,
  email,
  password,
  number,
  date,
  phone,
  multiline,
}

/// A customizable form input field widget with support for:
/// - Text input types
/// - Password visibility toggle
/// - Date picker
/// - Voice input (via mic)
/// - Custom validation
class VoiceFormField extends StatefulWidget {
  /// A unique identifier used for voice recognition context
  final String fieldId;

  /// Callback when mic icon is tapped
  final Function(String fieldId)? onMicTap;

  /// Controller for the input field
  final TextEditingController controller;

  /// Placeholder or hint text shown inside the field
  final String? hint;

  /// Height of the form field in logical pixels
  final int? height;

  /// Width of the form field in logical pixels
  final int? width;

  /// Font size of the input text
  final int fontSize;

  /// Max/min/error lines for multi-line fields
  final int? maxLines, minLines, errorMaxLines;

  /// Custom keyboard type (if needed)
  final TextInputType? keyboardType;

  /// Border color used when focused
  final Color borderColor;

  /// Label displayed above the input field
  final String? label;

  /// Enable or disable voice input mic
  final bool enableVoice;

  /// Optional custom suffix icon
  final IconButton? suffixIconButton;

  /// Autofocus the field on load
  final bool? autofocus, autocorrect;

  /// Action button on the keyboard (e.g. next/done)
  final TextInputAction? textInputAction;

  /// How to auto validate the field
  final AutovalidateMode? autoValidateMode;

  /// Padding around the field
  final EdgeInsets? padding;

  /// Optional validator function
  final String? Function(String?)? validator;

  /// Type of the form field (determines behavior)
  final FormFieldType fieldType;

  /// Optional input border customizations
  final InputBorder? enabledBorder,
      border,
      focusedErrorBorder,
      focusedBorder,
      errorBorder,
      disabledBorder;

  const VoiceFormField({
    super.key,
    required this.controller,
    this.hint,
    this.height,
    this.width,
    this.fontSize = 16,
    this.borderColor = Colors.blue,
    this.label,
    this.enableVoice = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.errorMaxLines = 1,
    this.keyboardType,
    this.suffixIconButton,
    this.autofocus = false,
    this.autocorrect = false,
    this.textInputAction,
    this.autoValidateMode,
    this.padding,
    this.enabledBorder,
    this.border,
    this.focusedErrorBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.validator,
    required this.fieldType,
    required this.fieldId,
    this.onMicTap,
  });

  @override
  State<VoiceFormField> createState() => _VoiceFormFieldState();
}

class _VoiceFormFieldState extends State<VoiceFormField> {
  // Instance of the speech-to-text service
  final _speechService = SpeechToTextService();

  // Checks if the speech service is currently listening for this field
  bool get _isListening =>
      _speechService.isListening &&
      _speechService.currentFieldId == widget.fieldId;

  // For toggling password visibility
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final showVoice = widget.enableVoice && _isVoiceSupported(widget.fieldType);
    final isDate = widget.fieldType == FormFieldType.date;
    final isPassword = widget.fieldType == FormFieldType.password;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: (widget.height ?? 60).toDouble(),
            width: (widget.width ?? 330).toDouble(),
            child: TextFormField(
              controller: widget.controller,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              autofocus: widget.autofocus ?? false,
              autocorrect: widget.autocorrect ?? false,
              autovalidateMode: widget.autoValidateMode,
              style: TextStyle(fontSize: widget.fontSize.toDouble()),
              keyboardType: _getKeyboardType(widget.fieldType),
              obscureText: isPassword ? obscureText : false,
              textInputAction: widget.textInputAction,
              readOnly: isDate, // Make field non-editable if it's a date
              onTap: isDate ? _pickDate : null,
              validator:
                  widget.validator ?? _defaultValidator(widget.fieldType),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                labelText: widget.label,
                hintText: widget.hint,
                border: widget.border ??
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: widget.enabledBorder ??
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: widget.focusedBorder ??
                    OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                errorBorder: widget.errorBorder ??
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedErrorBorder: widget.focusedErrorBorder ??
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

                // Suffix section for icons: password visibility, calendar, mic, etc.
                suffixIcon: SizedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (isPassword)
                        IconButton(
                          icon: Icon(obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => obscureText = !obscureText),
                        ),
                      if (isDate)
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickDate,
                        ),
                      if (widget.suffixIconButton != null)
                        widget.suffixIconButton!,
                      if (showVoice)
                        IconButton(
                          onPressed: () {
                            widget.onMicTap?.call(widget.fieldId);
                            _toggleVoiceInput();
                          },
                          icon: Icon(_isListening ? Icons.mic : Icons.mic_off),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Toggles the voice input using the speech-to-text service.
  Future<void> _toggleVoiceInput() async {
    if (_isListening) {
      await _speechService.stopListening();
      setState(() {});
    } else {
      await _speechService.toggleListening(
        fieldId: widget.fieldId,
        controller: widget.controller,
        onResult: (text) => setState(() {}),
        onStatus: (status) => setState(() {}),
        onError: (err) => setState(() {}),
      );
    }
  }

  /// Returns the appropriate keyboard type for the specified field type.
  TextInputType _getKeyboardType(FormFieldType type) {
    switch (type) {
      case FormFieldType.email:
        return TextInputType.emailAddress;
      case FormFieldType.number:
        return TextInputType.number;
      case FormFieldType.phone:
        return TextInputType.phone;
      case FormFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  /// Provides default validation logic based on the field type.
  String? Function(String?) _defaultValidator(FormFieldType type) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'This field cannot be empty';
      }

      if (type == FormFieldType.email &&
          !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(value)) {
        return 'Please enter a valid email address';
      }

      if (type == FormFieldType.number && !RegExp(r'^\d+$').hasMatch(value)) {
        return 'Enter a valid number';
      }

      if (type == FormFieldType.phone) {
        final phoneDigits = value.replaceAll(RegExp(r'\D'), '');
        if (phoneDigits.length != 10) {
          return 'Phone number must be exactly 10 digits';
        }
        if (!RegExp(r'^\d{10}$').hasMatch(phoneDigits)) {
          return 'Enter a valid phone number';
        }
      }

      return null;
    };
  }

  /// Determines if voice input is supported for the current field type.
  bool _isVoiceSupported(FormFieldType type) {
    return type != FormFieldType.password && type != FormFieldType.date;
  }

  /// Opens a date picker and fills the field with the selected date.
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {});
    }
  }
}
