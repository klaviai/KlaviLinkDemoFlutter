# klavi_link_demo_flutter

Use webview_flutter  as WebView component to load ki Link for authorization and data sharing.

For iOS and Android clients, use different implementations due to compatibility issues.

Flutter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:klavi_link_demo_flutter/utils/launch_app.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    _webViewController = WebViewController.fromPlatformCreationParams(params);

    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
        if (request.url == 'about:blank') {
          return NavigationDecision.prevent;
        }
        if (!request.url.startsWith('http') &&
            !request.url.startsWith('https')) {
          LaunchApp.open(request.url);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      }));
  }

  @override
  Widget build(BuildContext context) {
    final String url = GoRouterState.of(context).extra! as String;
    _webViewController.loadRequest(Uri.parse(url));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Web'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: WebViewWidget(controller: _webViewController)),
          ],
        ));
  }
}


LaunchApp

iOS use flutter package url_launcher (launchUrl) to open the third party app via Universal Links/ URL Schemes.

Android  has compatibility problem, can't open ‘intent://xxx’, so we use Flutter to call Android's native module to realize to open third party APP through Deep Links.construct the channel

const methodChannel = MethodChannel('com.klavi.link.demo/launchApp');

invoke a method on the method channel

methodChannel.invokeMethod('launchApp', url);

import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

const methodChannel = MethodChannel('com.klavi.link.demo/launchApp');

class LaunchApp {
  static Future open(String url) async {
    try {
      if (Platform.isAndroid) {
        return methodChannel.invokeMethod('launchApp', url);
      }
      return launchUrl(Uri.parse(url));
    } catch (e) {
      log('can\'t launch app: $e');
    }
  }
}


Android Supplement

launchUrl has compatibility problem in android, it can't be used, so we use Flutter to call Android's native module to realize opening third-party APP through Deep Links.
Reference: https://docs.flutter.dev/platform-integration/platform-channels 

MainActivity.kt

Inside the configureFlutterEngine() method, create a MethodChannel and call setMethodCallHandler(). Make sure to use the same channel name as was used on the Flutter client side.

package com.example.klavi_link_demo_flutter

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.URISyntaxException

class MainActivity: FlutterActivity() {
    private var CHANNEL = "com.klavi.link.demo/launchApp"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "launchApp") {
                val uri = Uri.parse(call.arguments())
                try {
                    val intent = if (uri.scheme == "intent") {
                        Intent.parseUri(uri.toString(), Intent.URI_INTENT_SCHEME)
                    } else {
                        Intent(Intent.ACTION_VIEW, uri)
                    }
                    startActivity(intent)
                } catch (e: ActivityNotFoundException) {
                    e.printStackTrace()
                } catch (e: URISyntaxException) {
                    e.printStackTrace()
                }
                result.success("launchApp success")
            } else {
                result.notImplemented()
            }
        }
    }
}


GitHub

https://github.com/klaviai/KlaviLinkDemoFlutter 

Download

https://www.pgyer.com/WHnXU8
