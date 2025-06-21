import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  static final SpeechToTextService _instance = SpeechToTextService._internal();
  factory SpeechToTextService() => _instance;

  late final stt.SpeechToText _speech;
  bool _isListening = false;
  String? _currentFieldId;

  String? get currentFieldId => _currentFieldId;
  bool get isListening => _isListening;

  SpeechToTextService._internal() {
    _speech = stt.SpeechToText();
  }

  Future<void> toggleListening({
    required String fieldId,
    required TextEditingController controller,
    void Function(String text)? onResult,
    void Function(String status)? onStatus,
    void Function(String error)? onError,
  }) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          _isListening = status == 'listening';
          if (!_isListening) _currentFieldId = null;
          onStatus?.call(status);
        },
        onError: (error) {
          _isListening = false;
          _currentFieldId = null;
          onError?.call(error.errorMsg);
        },
      );

      if (available) {
        _isListening = true;
        _currentFieldId = fieldId;
        _speech.listen(
          onResult: (result) {
            final text = result.recognizedWords;
            controller.text = text;

            onResult?.call(text);
            if (result.finalResult) {
              _speech.stop();
              _isListening = false;
              _currentFieldId = null;
            }
          },
        );
      } else {
        onError?.call("Speech recognition not available.");
      }
    } else {
      await _speech.stop();
      _isListening = false;
      _currentFieldId = null;
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
    _isListening = false;
    _currentFieldId = null;
  }
}
