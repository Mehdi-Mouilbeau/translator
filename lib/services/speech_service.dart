import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;

  Future<void> init() async {
    _isInitialized = await _speech.initialize(
      onStatus: (status) {
        print("Status: $status");
      },
      onError: (error) {
        print("Speech error: $error");
      },
    );
  }

  Future<void> startListening(Function(String) onFinalResult) async {
    if (!_isInitialized) {
      print("Speech not initialized");
      return;
    }

    await _speech.listen(
      localeId: "fr_FR",
      onResult: (result) {
        print("Texte détecté: ${result.recognizedWords}");
        print("Final: ${result.finalResult}");

        if (result.finalResult) {
          final text = result.recognizedWords.trim();

          if (text.isNotEmpty) {
            onFinalResult(text);
          } else {
            print("Texte final vide ignoré");
          }
        }
      },
    );
  }

  Future<void> stop() async {
    await _speech.stop();
  }
}
