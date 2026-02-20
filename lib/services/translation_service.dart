import 'package:cloud_functions/cloud_functions.dart';

class TranslationService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<String> translate(String text, {String targetLanguage = 'en'}) async {
    print("Envoi à Firebase: $text");

    final callable = _functions.httpsCallable('translateText');

    final response = await callable.call({
      'text': text,
      'targetLanguage': targetLanguage,
    });

    print("Réponse brute Firebase: ${response.data}");

    return response.data['translatedText'] ?? "";
  }
}