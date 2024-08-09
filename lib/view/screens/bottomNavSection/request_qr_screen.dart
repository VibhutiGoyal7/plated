import 'dart:io';
import 'dart:typed_data';

import 'package:Payrio/languageSection/Languages.dart';
import 'package:Payrio/model/requestQRData.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/view/screens/profileSection/settingSection/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'package:image/image.dart' as img;
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';

class RequestQrScreen extends StatefulWidget {
  @override
  _RequestQrScreenState createState() => _RequestQrScreenState();
}

class _RequestQrScreenState extends State<RequestQrScreen> {
  late double screenWidth;
  late double screenHeight;
  Uint8List? qrCodeImage;
  bool isQrCodeGenerated = false;
  String phoneCode = "+";
  int countryCode = 0;
  bool isLoading = false;
  bool isValid = false;
  bool isOtpBoxVisible = false;
  String username = '';
  late RequestQRData data;

  bool isUsernameRetrieved = false;
  String otp = '';
  String currencySymbol = '';
  bool phoneNumberValid = false;
  bool isDarkMode = false;
  String selectedItem = "";
  final _repaintBoundaryKey = GlobalKey();

  final TextEditingController _amountController = TextEditingController();
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    isValid = false;
    phoneNumberValid = false;
    Helper.getProfileDetails().then((profileDetails) {
      setState(() {
        username = "${profileDetails?.username}";
        isUsernameRetrieved = true;
      });
    });
    Helper.getCurrencySymbol().then((symbol) {
      setState(() {
        currencySymbol = "${symbol}";
      });
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Stack(children: [
      GestureDetector(
        onTap: ()=> hideKeyBoard(),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 65,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                hideKeyBoard();
                Navigator.pop(context);
              },
            ),
            title: Text(
              "${Languages.of(context)?.labelRequestQR}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
          ),
          //backgroundColor: Theme.of(context).backgroundColor,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      Center(
                        child: Image(
                          alignment: Alignment.topLeft,
                          //width: screenWidth*0.8,
                          height: screenHeight * 0.2,
                          image: AssetImage("assets/requestQR.png"),
                        ),
                      ),
                      _buildAddMoneyInput(context, "0.00"),
                      _buildFooter(context)
                    ],
                  ),
                ),
              ),
              isLoading
                  ? Stack(
                      children: [
                        // Block interaction
                        ModalBarrier(
                            dismissible: false,
                            color: Colors.transparent),
                        // Loader indicator
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    ]);
  }

  void isInputValid() {
   // String otp = _controllers.map((controller) => controller.text).join();
    if (_amountController.text.isNotEmpty && _amountController.text.length>=1 ) {
      isValid = true;
    } else {
      isValid = false;
    }
  }

  Widget _buildAddMoneyInput(
    BuildContext context,
    String text,
    //TextEditingController amountController,
    //TextEditingController nameController, Icon icon
  ) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "${Languages.of(context)?.labelAddMoney}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                ),
              ),
              Card(
                child: Container(
                  height: 55,
                  width: screenWidth * 0.88,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border(
                        right: BorderSide(width: 0.2),
                        top: BorderSide(width: 0.250),
                        bottom: BorderSide(width: 0.2),
                        left: BorderSide(width: 0.2),
                      )),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                    obscureText: false,
                    autofocus: true,
                    obscuringCharacter: "*",
                    controller: _amountController,
                    onChanged: (value) {
                      setState(() {
                        _amountController.text = value;
                      });
                      isInputValid();
                    },
                    /*   inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // This allows only digits (0-9)
                    ],*/
                    maxLength: 6,
                    textAlign: TextAlign.left,
                    onSubmitted: (value) {},
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: text,
                        hintStyle: TextStyle(color: Colors.grey),
                        alignLabelWithHint: true),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          SizedBox(
            width: screenWidth * 0.7,
            child: ElevatedButton(
              onPressed: () async {
                hideKeyBoard();
                isInputValid();
                print(_amountController.text);
                if (isValid) {
                  data = RequestQRData(amount: '${_amountController.text}', username: '$username');
                  generateQrCode("$username-${_amountController.text}");

                /*  setState(() {
                    isLoading = true;
                  });

                  bool isConnected = await _connectivityService.isConnected();
                  if (!isConnected) {
                    setState(() {
                      isLoading = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${Languages.of(context)?.labelNoInternetConnection}',
                            style: TextStyle(color: AppColor.WHITE),
                          ),
                          duration: maxDuration,
                        ),
                      );
                    });
                  } else {
                    AddMoneyRequest request = AddMoneyRequest(
                        amount: int.parse(_amountController.text));

                    await Provider.of<MainViewModel>(context, listen: false)
                        .addMoneyData(
                        "api/v1/app/payment_transactions/add_money_to_wallet",
                        request);

                    ApiResponse apiResponse =
                        Provider.of<MainViewModel>(context, listen: false)
                            .response;
                    getAddMoneyResponse(context, apiResponse);
                  }*/
                }
              },
              child: Text(
                "${Languages.of(context)?.labelGenerateQR}",
                style:
                    TextStyle(color: isValid ? Colors.white : AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: isValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> generateQrCode(String data) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode!,
        color: Colors.black,
        emptyColor: Colors.white,
        gapless: true,
      );

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/qr_code.png';
      final imageFile = File(imagePath);

      final picData = await painter.toImageData(190);
      final bytes = picData!.buffer.asUint8List();

      final image = img.decodeImage(bytes);
      final png = img.encodePng(image!);
      await imageFile.writeAsBytes(png);

      setState(() {
        qrCodeImage = bytes as Uint8List?;
        print(qrCodeImage);
        isQrCodeGenerated = true;
      });
      hideKeyBoard();
      _showModal(context,);
    }
  }

  void _showModal(BuildContext context) {

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              scrollable: true,
              insetPadding: EdgeInsets.all(8),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 8, vertical: 35),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*GestureDetector(
                    onTap: () => {},
                    child: imageUrl == ""
                        ? Container(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.WHITE,
                        backgroundImage:
                        AssetImage("assets/profile_user.png"),
                      ),
                    )
                        : ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.network(
                          imageUrl,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context,
                              Object exception, StackTrace? stackTrace) {
                            // You can return any widget here to display in case of an error
                            return Container(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColor.WHITE,
                                backgroundImage: AssetImage(
                                  "assets/profile_user.png",
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (BuildContext context,
                              Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Shimmer.fromColors(
                                baseColor: Colors.black54,
                                highlightColor: Colors.black45,
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? Shimmer.fromColors(
                    baseColor: Colors.white38,
                    highlightColor: Colors.grey,
                    child: Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust the radius as needed
                      ),
                    ),
                  )
                      : _buildLabelText(context, customerName.toString(), 14.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoading
                          ? Shimmer.fromColors(
                        baseColor: Colors.white38,
                        highlightColor: Colors.grey,
                        child: Container(
                          width: 100,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust the radius as needed
                          ),
                        ),
                      )
                          : Text(
                        userName,
                        style: TextStyle(fontSize: 14.0),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      isLoading
                          ? SizedBox()
                          : GestureDetector(
                        onTap: () => {
                          copyTextToClipboard(userName.toString()),
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                Text("Text copied to clipboard")),
                          )
                        },
                        child: Icon(
                          Icons.copy,
                          size: 16,
                        ),
                      )
                    ],
                  ),*/
                  Text(
                    "Requested amount : ${addCurrencySymbol(currencySymbol,"${_amountController.text}", )}",
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 20,
                  ),
              isUsernameRetrieved && isQrCodeGenerated
                  ? //Text("data")
              qrCodeImage != null
                  ? Image.memory(qrCodeImage!,
              )
                  : Text("${Languages.of(context)?.labelErrorLoadingQR}")
                  : Shimmer.fromColors(
                baseColor: Colors.white38,
                highlightColor: Colors.grey,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
