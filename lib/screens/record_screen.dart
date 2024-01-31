import 'package:flutter/material.dart';

import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  late AudioRecorder record;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';

  @override
  void initState() {
    // TODO: implement initState
    record = AudioRecorder();
    audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    record.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    print('start recording...');
    try {
      if (await record.hasPermission()) {
        await record.start(const RecordConfig(), path: 'aFullPath/myFile.m4a');
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print('Error al comenzar a grabar: $e');
    }
  }

  Future<void> stopRecording() async {
    print('stop recording...');
    try {
      String? path = await record.stop();

      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {
      print('Error al terminar de grabar: $e');
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(
        audioPath,
      );
      audioPlayer.play(urlSource);
    } catch (e) {
      print('Error al reproducir el audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to text'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isRecording
                ? const Text('Grabando...')
                : const Text('Presiona el botón para grabar'),
            ElevatedButton(
              onPressed: startRecording,
              child: const Text('Start recording'),
            ),
            ElevatedButton(
                onPressed: stopRecording, child: const Text('Stop recording')),
            const SizedBox(height: 25),
            !isRecording && audioPath.isNotEmpty
                ? ElevatedButton(
                    onPressed: playRecording,
                    child: const Text('Reproducir grabación'),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
