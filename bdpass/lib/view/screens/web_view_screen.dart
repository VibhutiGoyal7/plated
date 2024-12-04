import 'dart:async';
import 'dart:io';

import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/model/response/trxStatusResponse.dart';
import 'package:BDPass/model/webviewData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../model/apis/api_response.dart';
import '../../theme/AppColor.dart';
import '../../utils/Util.dart';
import '../../view_model/main_view_model.dart';
import '../component/connectivity_service.dart';
import '../component/session_expired_dialog.dart';

class WebViewScreen extends StatefulWidget {
  final WebViewData? data;

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

  static const maxDuration = Duration(seconds: 2);

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

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
            await Future.delayed(Duration(seconds: 6));
            Navigator.pushReplacementNamed(context, "/BottomNav");
          }
          setState(() {
            loadingPercentage = 100;
          });

          fetchData();
        },
      ))
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          print("ToasterService $message");
        },
      )
      ..loadRequest(
        Uri.parse("${widget.data?.redirectUrl}"),
      );

    if (controller?.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller?.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);

    }
    if (Platform.isAndroid && controller?.platform is AndroidWebViewController) {
      final AndroidWebViewController androidController =
      controller?.platform as AndroidWebViewController;

      androidController.setJavaScriptMode(JavaScriptMode.unrestricted);
      androidController.setMediaPlaybackRequiresUserGesture(false);
      // Access WebSettings to allow mixed content
     // androidController.settings.setMixedContentMode(AndroidMixedContentMode.compatibility);
    }
  }

  @override
  void dispose() {
    controller = null;
    _timer.cancel();
      _isActive = false;
    super.dispose();
  }


  Future<Widget> getTrxStatusResponse(
      BuildContext context, ApiResponse apiResponse) async {
    TrxStatusResponse? addMoneyResponse = apiResponse.data as TrxStatusResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
       // Navigator.pushReplacementNamed(context, "/BottomNav");
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") == nonCapitalizeString("${Languages.of(context)?.labelInvalidAccessToken}"))
          SessionExpiredDialog.showDialogBox(context: context);
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
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

    controller?..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')
      //..clearCache()
      ..runJavaScriptReturningResult(jsScript
    ).then((result) {
      String trimmedResult = result.toString().trim();

      print('JavaScript executed: $trimmedResult');

      // Compare trimmed result
      if (_isActive) {
        if (trimmedResult.contains("Requested AmountPayment Method")) {
          print('Match found: $trimmedResult');
          fetchStatus();
         // Navigator.pushReplacementNamed(context, "/BottomNav");
        } else if (trimmedResult.contains("Requested Amount")) {
          print('Match found: $trimmedResult');
          fetchStatus();
         // Navigator.pushReplacementNamed(context, "/BottomNav");
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
          widget.data?.transactionType == '${Languages.of(context)?.labelAddMoney}'?
          "${Languages.of(context)?.labelAddMoney}" :
          '${Languages.of(context)?.labelWithdraw}',
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

  Future<void> fetchStatus() async {
    setState(() {
      isLoading = true;
    });

    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${Languages.of(context)?.labelNoInternetConnection}",
              style: TextStyle(color: AppColor.WHITE),
            ),
            duration: maxDuration,
          ),
        );
      });
    } else {
     /* TrxStatusRequest request = TrxStatusRequest(
          uniqueId: "${widget.data?.uniqueId}");*/
      if(mounted) {
       /* await Provider.of<MainViewModel>(context, listen: false)
            .trxStatusData(
            "api/v1/app/wallet_transactions/update_pay2local_trx_status",
            request);*/

        ApiResponse apiResponse =
            Provider
                .of<MainViewModel>(context, listen: false)
                .response;
        getTrxStatusResponse(context, apiResponse);
      }
    }
  }
}
