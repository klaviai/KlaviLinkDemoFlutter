import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final WebViewController _webViewController;

  static const whiteList = [
    "open.klavi.tech",
    "open-sandbox.klavi.ai",
    "open-testing.klavi.ai",
    "open.klavi.ai",
  ];

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
        try {
          Uri requestUri = Uri.parse(request.url);
          if (whiteList.contains(requestUri.host)) {
            return NavigationDecision.navigate;
          }
          await launchUrl(requestUri, mode: LaunchMode.externalApplication);
          return NavigationDecision.prevent;
        } catch (e) {
          debugPrint('e: $e');
          return NavigationDecision.prevent;
        }
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
