import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:object_detection/controller.dart';
import 'package:object_detection/realtime/bounding_box.dart';
import 'package:object_detection/realtime/camera.dart';
import 'dart:math' as math;
import 'package:tflite/tflite.dart';
import 'package:translator/translator.dart';

class LiveFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  LiveFeed(this.cameras);
  @override
  _LiveFeedState createState() => _LiveFeedState();
}

enum TtsState { playing, stopped, paused, continued }

class _LiveFeedState extends State<LiveFeed> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  FlutterTts flutterTts = FlutterTts();
  GoogleTranslator translator;
  String object = '';
  String text;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  TtsState ttsState = TtsState.stopped;
  initCameras() async {}
  loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/models/ssd_mobilenet.tflite",
      labels: "assets/models/labels.txt",
    );
  }

  /* 
  The set recognitions function assigns the values of recognitions, imageHeight and width to the variables defined here as callback
  */
  setRecognitions(recognitions, imageHeight, imageWidth) async {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });

    final input = "${_recognitions[0]["detectedClass"]}";
    translator.translate(input, to: 'tr').then((value) {
      text = value.toString();
      print(value.toString());
      print(
          '---- isPlaying: ${ttsState != TtsState.playing} --- Same object= ${object != value.toString()}');
      if (ttsState != TtsState.playing && object != value.toString()) {
        _speak(value.toString());
        print(value.toString());
      }
    }).toString();
    //print(newText);
  }

  Future _speak(String text) async {
    object = text;
    var result = await flutterTts.speak(text);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  @override
  void initState() {
    super.initState();
    loadTfModel();

    translator = GoogleTranslator();
    translator.translate('sourceText', to: 'tr');
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CameraFeed(widget.cameras, setRecognitions),
          BoundingBox(
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
              text),
          Positioned(
              child: Container(
            padding: EdgeInsets.only(
              top: 36,
              left: 8,
              bottom: 8,
            ),
            color: Colors.black.withOpacity(0.2),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
