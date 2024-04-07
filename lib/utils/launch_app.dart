import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

const methodChannel = MethodChannel('com.klavi.flutter.launch-app');

class LaunchApp {
  static Future open(String url) async {
    try {
      if (Platform.isAndroid) {
       return methodChannel.invokeMethod('launchApp', url);
      } else {
       return launchUrl(Uri.parse(url));
      }
    } catch (e) {
      log('can\'t launch app: $e');
    }
  }
}
