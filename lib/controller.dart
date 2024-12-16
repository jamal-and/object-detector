import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import 'realtime/live_camera.dart';

class ControllerX extends GetxController {
  FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;
  updateState(TtsState ttsStatPar) {
    ttsState = ttsStatPar;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    print(await flutterTts.getEngines);
    print('language Ava? ${await flutterTts.isLanguageAvailable("tr")}');
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);
    flutterTts.setLanguage('tr');
    flutterTts.setStartHandler(() {
      print("Playing");
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
      ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
      ttsState = TtsState.stopped;
    });
  }

  @override
  void onReady() async {
    super.onReady();
    print(await flutterTts.getEngines);
    print('language Ava? ${await flutterTts.isLanguageAvailable("tr")}');
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);
    flutterTts.setLanguage('tr');
    flutterTts.setStartHandler(() {
      print("Playing");
      ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
      ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
      ttsState = TtsState.stopped;
    });
  }
}
