import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
  import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewScreen extends StatefulWidget {
  //const WebViewStack({super.key});
  final String? data; // Define the 'data' parameter here

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
        onPageFinished: (url) {
          print("uRL:::{url}");
          if(url.contains("https://shopkeeper-kappa.vercel.app/shopkeeper")){
            Navigator.pushReplacementNamed(context, "/BottomNav");
          }
          setState(() {
            loadingPercentage = 100;
          });

          fetchData();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(warningText)),
          );
        },
      ))
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          print("ToasterService $message");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
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
      if(_isActive) {
        if (trimmedResult.contains("Requested AmountPayment Method")) {
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
    /*var script = '''
      var requestIdElement = document.querySelector('.rounded mb-3');
      var requestId = document.querySelector('.form-title');
      requestId ? requestId.textContent.trim() : '';
    ''';
    //binding.webView!!.loadUrl("javascript:(function(){var element = document.getElementsByName('username');element[0].focus();document.execCommand('insertText', false, '$userLogin');})()")

    var result = await controller.runJavaScriptReturningResult(script).then((value) {
      // Handle extracted data
      print('Request ID: $value');
      // Update your UI or save the value as needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request ID: $value')),
      );
    });*/
    /* if(mounted) {
      print("warningText $result");
    }
    setState(() {
      warningText = result.toString(); // Remove quotes from extracted text
    });*/
  }

  @override
  Widget build(BuildContext context) {
    print("redirectUrl: ${widget.data}");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Money",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
