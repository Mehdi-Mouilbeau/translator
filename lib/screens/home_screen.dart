import 'package:flutter/material.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../services/translation_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechService _speechService = SpeechService();
  final TTSService _ttsService = TTSService();
  final TranslationService _translationService = TranslationService();

  String originalText = "";
  String translatedText = "";
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    await _speechService.init();
  }

  void startConversation() {
    if (isListening) return;

    setState(() => isListening = true);

    _speechService.startListening((text) async {
      final cleaned = text.trim();

      // 🔥 PROTECTION ABSOLUE
      if (cleaned.isEmpty) {
        print("Texte vide ignoré AVANT Firebase");
        return;
      }

      print("Texte envoyé à Firebase: $cleaned");

      try {
        final translated = await _translationService.translate(cleaned);

        if (translated.trim().isEmpty) {
          print("Traduction vide ignorée");
          return;
        }

        print("Traduction reçue: $translated");

        setState(() {
          originalText = cleaned;
          translatedText = translated;
        });

        await _ttsService.speak(translated, "en-US");
      } catch (e) {
        print("Erreur traduction: $e");
      }
    });
  }

  Future<void> stopConversation() async {
    await _speechService.stop();
    setState(() => isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice Translator Pro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Original: $originalText"),
            const SizedBox(height: 20),
            Text("Translated: $translatedText"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: isListening ? stopConversation : startConversation,
              child: Text(
                isListening ? "Stop Conversation" : "Start Conversation",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
