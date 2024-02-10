import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

import 'package:intl/intl.dart';
import 'package:voice_in/screens/home/widgets/messages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  final FlutterTts _flutterTts = FlutterTts();
  List<Map> _voices = [];
  Map? _currentVoice;

  // Dialogflow
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTTS();
    _initDialogflow();
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }

  // Dialogflow
  void _initDialogflow() async {
    DialogAuthCredentials credentials =
        await DialogAuthCredentials.fromFile('assets/dialog_flow_auth.json');

    dialogFlowtter = DialogFlowtter(
        credentials: credentials, sessionId: 'asistente-virtual-ihc-vdlj');
  }

  void sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      addMessage(
        Message(text: DialogText(text: [text])),
        true,
      );
    });

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(
        text: TextInput(
          text: text,
          languageCode: "es",
        ),
      ),
    );

    if (response.message == null) return;
    setState(() {
      addMessage(response.message!);
      // print(response.message!.text!.text![0]);
      _flutterTts.speak(response.message!.text!.text![0]);
    });
  }

  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }
  // End Dialogflow

  // TTS FLUTTR
  void _initTTS() {
    _flutterTts.setProgressHandler((text, start, end, word) {
      // setState(() {
      //   _currentWordStart = start;
      //   _currentWordEnd = end;
      // });
    });
    _flutterTts.getVoices.then((data) {
      try {
        _voices = List<Map>.from(data);
        setState(() {
          final voicesEs =
              _voices.where((voice) => voice['name'].contains('es')).toList();
          _currentVoice = voicesEs.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        // print(e);
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice['name'], 'locale': voice['locale']});
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    // final locales = await _speechToText.locales();
    // for (var element in locales) {
    //   print(element.localeId);
    // }
    try {
      await _speechToText.listen(onResult: _onSpeechResult, localeId: 'es_ES');
    } catch (e) {
      print('OCURRRIO UN ERROR: $e');
    }
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      sendMessage(_lastWords);
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      // _controller.text = _lastWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              'VoiceIn',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10, // Ancho del círculo
                  height: 10, // Alto del círculo
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green, // Color de fondo del círculo
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                "Hoy, ${DateFormat("Hm").format(DateTime.now())}",
                style: const TextStyle(fontSize: 20),
              ),
            ),

            Messages(messages: messages),

            ListTile(
              title: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                    color: Colors.grey.shade500,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Mensaje",
                    hintStyle: TextStyle(color: Colors.black26),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  onChanged: (value) {},
                ),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Escuchar',
                      color: Colors.black,
                      onPressed: _speechToText.isNotListening
                          ? _startListening
                          : _stopListening,
                      icon: Icon(_speechToText.isNotListening
                          ? Icons.mic_off
                          : Icons.mic),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        size: 30.0,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15.0),
            //END
          ],
        ),
      ),
    );
  }
}
