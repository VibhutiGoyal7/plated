import 'dart:developer';
import 'dart:io';

import 'package:BDOne/model/request/checkCustomerRequest.dart';
import 'package:BDOne/model/response/checkCustomerReponse.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../languageSection/Languages.dart';
import '../../model/apis/api_response.dart';
import '../../view_model/main_view_model.dart';
import '../component/connectivity_service.dart';
import '../component/custom_loader.dart';
import '../component/toastMessage.dart';

class ScanQrScreen extends StatefulWidget {
  @override
  _ScanQrScreenState createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var flashLightOff = "true";
  static const maxDuration = Duration(seconds: 2);
  String amount = "";
  String username = "";

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColor.BLACK,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Container(
      margin: EdgeInsets.only(bottom: 0),
      child: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderColor: AppColor.PRIMARY,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                    onTap: () async {
                      await controller?.toggleFlash();
                      setState(() {
                        flashLightOff = "${controller?.getFlashStatus()}";
                      });
                    },
                    child: FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        return "${snapshot.data}" == "false"
                            ? Icon(
                                Icons.flashlight_off,
                                size: 28,
                              )
                            : Icon(
                                Icons.flashlight_on,
                                size: 28,
                              );
                        //Text('Flash: ${snapshot.data}');
                      },
                    )),
              ),
            ],
          ),
          isLoading
              ? Center(
                  child: CustomLoader(),
                )
              : SizedBox()
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      // reassemble();
      controller.pauseCamera();
      _initiateTransaction("${result!.code}");
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> _initiateTransaction(String data) async {
    setState(() {
      isLoading = true;
    });
    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${Languages.of(context)?.labelNoInternetConnection}'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      if(data.contains("-")){
      List<String> splitData = data.split("-");

      username = splitData[0];
       amount = splitData[1];
      }else{
        username = data;
      }

      CheckCustomerRequest request =
          CheckCustomerRequest(username: username, phoneNo: null);
     /* await Provider.of<MainViewModel>(context, listen: false)
          .checkCustomerByUsername(
              "api/v1/app/customers/check_customer_by_username", request);*/
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      initiateCheckCustomerResponse(context, apiResponse, username);
    }
  }

  Future<Widget> initiateCheckCustomerResponse(
      BuildContext context, ApiResponse apiResponse, String userName) async {
    CheckCustomerResponse? checkCustomerResponse = apiResponse.data;
    var message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomLoader());
      case Status.COMPLETED:
        print("pushNamed $userName");
        checkCustomerResponse?.amount =amount;
        Navigator.pushNamed(context, '/TransferScreen',
            arguments: checkCustomerResponse);
        // Navigate to the new screen after receiving the response
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        ToastComponent.showToast(context: context, message: message);
        controller?.resumeCamera();
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
