import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:screenshot_detector/screenshot_detector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _screenShotDetector = ScreenshotDetector();

  @override
  void initState() {
    super.initState();

    _screenShotDetector.addListener(() => print('detected'));
  }

  // TODO: Exampleを書く

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(''),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _screenShotDetector.dispose();
    super.dispose();
  }
}
