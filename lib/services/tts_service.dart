import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text, String languageCode) async {
    await _tts.setLanguage(languageCode);
    await _tts.awaitSpeakCompletion(true);
    await _tts.speak(text);
  }
}
