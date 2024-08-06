import 'dart:async';

import 'package:Payrio/languageSection/Languages.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewScreen extends StatefulWidget {
  final String? data;

  WebViewScreen({Key? key, this.data}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  var loadingPercentage = 0;
  String span1 = '';
  String span2 = '';
  String warningText = '';
  WebViewController? controller;

  late Timer _timer;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 300), () {
      // Navigate back to the previous page
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    controller = WebViewController.fromPlatformCreationParams(params);
    controller
      ?..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) async {
          print("uRL:::{url}");
          if (url.contains("https://admin.payorio.com/")) {
            await Future.delayed(Duration(seconds: 10));
            Navigator.pushReplacementNamed(context, "/BottomNav");
          }
          setState(() {
            loadingPercentage = 100;
          });

         // fetchData();
        },
      ))
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          print("ToasterService $message");
        },
      )
      ..loadRequest(
        Uri.parse("${widget.data}"),
      );

    if (controller?.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller?.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  void dispose() {
    controller = null;
    if (_timer != null) {
      _timer.cancel();
    }
    _isActive = false;
    super.dispose();
  }

  void fetchData() async {
    // Ensure a reasonable delay to allow WebView to load content
    await Future.delayed(Duration(milliseconds: 10000));

    String jsScript = '''
  (function() {
    var element = document.getElementsByClassName('requested-amount')[0];
    if (element) {
      return element.textContent.trim();
    } else {
      return 'Element not found';
    }
  })();
  ''';

    controller?.runJavaScriptReturningResult(jsScript).then((result) {
      String trimmedResult = result.toString().trim();

      print('JavaScript executed: $trimmedResult');

      // Compare trimmed result
      if (_isActive) {
        if (trimmedResult.contains("Requested AmountPayment Method")) {
          print('Match found: $trimmedResult');
          Navigator.pushReplacementNamed(context, "/BottomNav");
        } else if (trimmedResult.contains("Requested Amount")) {
          print('Match found: $trimmedResult');
          Navigator.pushReplacementNamed(context, "/BottomNav");
        } else {
          fetchData();
          print('No match found: $trimmedResult');
        }
      }
    }).catchError((error) {
      print('Error executing JavaScript: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    print("redirectUrl: ${widget.data}");
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        title: Text(
          "${Languages.of(context)?.labelAddMoney}",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              controller: controller as WebViewController,
            ),
            if (loadingPercentage < 100)
              LinearProgressIndicator(
                value: loadingPercentage / 100.0,
              ),
          ],
        ),
      ),
    );
  }
}
