import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:object_detection/controller.dart';
import 'package:object_detection/realtime/live_camera.dart';
import 'package:object_detection/static%20image/static.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  // initialize the cameras when the app starts
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  Get.put(ControllerX());
  // running the app
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    //theme: ThemeData.dark(),
    theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.purple,
        buttonColor: Colors.purple,
        primaryColor: Colors.purple,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          splashColor: Colors.white.withOpacity(0.25),
          backgroundColor: Colors.purple,
        ),
        colorScheme: ColorScheme.fromSwatch(primaryColorDark: Colors.purple)),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                        child: Container(
                          child: Text(
                            'Object detector',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                        ),
                      ),
                      ButtonTheme(
                        minWidth: 170,
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.purple,
                                width: 4,
                              ),
                            ),
                            child: Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.purple,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StaticImage(),
                              ),
                            );
                          },
                        ),
                      ),
                      // SizedBox(
                      //   height: 64,
                      // ),
                      ButtonTheme(
                        minWidth: 160,
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.purple,
                                width: 4,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 80,
                              color: Colors.purple,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LiveFeed(cameras),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
