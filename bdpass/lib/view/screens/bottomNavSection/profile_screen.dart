import 'dart:io';

import 'package:BDPass/model/db/BDPassDatabase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/circluar_profile_image.dart';
import '../../component/connectivity_service.dart';
import '../../component/detail_box.dart';
import '../../component/session_expired_dialog.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? qrCodeImage;
  bool isUsernameRetrieved = false;
  bool isQrCodeGenerated = false;
  var customerName;
  var userName;
  var imageUrl;
  File? galleryFile;
  final picker = ImagePicker();
  bool isLoading = true;
  bool isDarkMode = false;
  bool isBiometricEnable = false;
  String dashBoardKycStatus = "";
  late double screenWidth;
  late double screenHeight;
  late BDPassDatabase database;
  static const maxDuration = Duration(seconds: 2);
  bool isTablet = false;

  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:
          Brightness.light, // Light icons for the status bar
      //statusBarBrightness: Brightness.dark,       // Status bar brightness (for iOS)
    ));
    customerName = "";
    userName = "";
    imageUrl = "";
    _fetchDataFromPref();
    _fetchData();
    $FloorBDPassDatabase
        .databaseBuilder('payorio_database.db')
        .build()
        .then((value) async {
      this.database = value;
    });

    Helper.getBiometric().then((retrievedBiometric) {
      setState(() {
        isBiometricEnable = retrievedBiometric ?? false; // Handle null case
        //isLoading = false; // Update loading state
      });
    });
    print(Helper.getUserToken());
  }

  Future<Widget> getProfileResponse(
      BuildContext context, ApiResponse apiResponse) async {
    ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    print("apiResponse${apiResponse.status}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(
            child: CircularProgressIndicator(
          color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY,
        ));
      case Status.COMPLETED:
        await Helper.saveProfileDetails(mediaList);
        await Helper.saveUserBalance(mediaList?.balance);
        await Helper.saveCountry(mediaList?.countryName);
        await Helper.saveKycStatus(mediaList?.kycStatus);
        print(mediaList?.countryName);
        dashBoardKycStatus = "${mediaList?.kycStatus}";
        _fetchDataFromPref();

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        _fetchDataFromPref();
        print("Message : ${apiResponse.message}");
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something went wrong.'),
              duration: maxDuration,
            ),
          );
        }
        print(apiResponse.message);
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
      final imagePath = '${directory.path}/qr_co de.png';
      final imageFile = File(imagePath);

      final picData = await painter.toImageData(170);
      final bytes = picData!.buffer.asUint8List();

      final image = img.decodeImage(bytes);
      final png = img.encodePng(image!);
      await imageFile.writeAsBytes(png);

      setState(() {
        qrCodeImage = bytes;
        print(qrCodeImage);
        isQrCodeGenerated = true;
      });
      //_showModal(context, userName);
    }
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isTablet = getIsTablet(context, screenWidth, screenHeight);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        if (kDebugMode) {
          Navigator.pushReplacementNamed(
            context,
            "/BottomNav",
            arguments: 0,
          );
          // return Future.value(true);
        }
        Navigator.pushReplacementNamed(
          context,
          "/BottomNav",
          arguments: 0,
        );
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (Platform.isIOS) {
            if (details.velocity.pixelsPerSecond.dx > 50) {
              if (isKeyboardOpen(context)) {
                hideKeyBoard();
              } else {
                Navigator.pushNamed(context, "/BottomNav", arguments: 0);
              }
            }
          }
        },
        onTap: () => {hideKeyBoard()},
        child: Scaffold(
          body: Stack(children: [
            AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                  statusBarColor: AppColor.PRIMARY,
                  statusBarIconBrightness: Brightness.light),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "${Languages.of(context)?.labelAccount}",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Card(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircularProfileImage(
                                      size: 50,
                                      imageUrl: imageUrl,
                                      name: customerName,
                                      needTextLetter: true,
                                      placeholderImage: "",
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Full Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          "${Languages.of(context)?.labelShowProfile}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9,
                                              color: Colors.black54),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        //decoration: BoxDecoration(color: AppColor.BG_COLOR),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: isTablet ? 0 : 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: isTablet ? 0 : 10.0),
                                        Text("${Languages.of(context)?.labelAccount}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  '/AccountDetailScreen',
                                                  arguments: "");
                                            },
                                            child: DetailBox(
                                              heading: "${Languages.of(context)?.labelChangePIN}",
                                              icon: Icons.key,
                                              headingTextSize: 14,
                                            )),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  '/PersonalInfoScreen',
                                                  arguments: "");
                                            },
                                            child: DetailBox(
                                              heading: "${Languages.of(context)?.labelManageDevices}",
                                              icon: Icons.phone_android,
                                              headingTextSize: 14,
                                            )),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/CardListScreen',
                                                  arguments:
                                                      "${Languages.of(context)!.labelAddedCard}");
                                            },
                                            child: DetailBox(
                                              heading: "${Languages.of(context)?.labelResetSigninPassword}",
                                              icon: Icons.password,
                                              headingTextSize: 14,
                                            )),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/SettingScreen',
                                                  arguments: "");
                                            },
                                            child: DetailBox(
                                              heading: "${Languages.of(context)?.labelBiometrics}",
                                              icon: Icons.border_inner_outlined,
                                              headingTextSize: 14,
                                            )),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/SettingScreen',
                                                  arguments: "");
                                            },
                                            child: DetailBox(
                                              heading: "${Languages.of(context)?.labelLanguage}",
                                              icon: Icons.abc_outlined,
                                              headingTextSize: 14,
                                            )),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/SettingScreen',
                                                  arguments: "");
                                            },
                                            child: DetailBox(
                                              heading: "${Languages.of(context)?.labelAccessibility}",
                                              icon: Icons.accessibility,
                                              headingTextSize: 14,
                                            )),
                                        Text("${Languages.of(context)?.labelMore}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  '/AccountBenefitScreen',
                                                  arguments: "");
                                            },
                                            child: DetailBox(
                                              heading: "${Languages.of(context)?.labelAboutBDPass}",
                                              icon: Icons.fingerprint,
                                              headingTextSize: 14,
                                            )),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/SettingScreen',
                                                  arguments: "");
                                            },
                                            child: DetailBox(
                                              heading: "${Languages.of(context)?.labelWalkthrough}",
                                              icon: Icons.play_arrow_rounded,
                                              headingTextSize: 14,
                                            )),
                                        GestureDetector(
                                            onTap: () {
                                              _showLogOutDialog();
                                            },
                                            child: _buildCard(
                                                context,
                                                "${Languages.of(context)?.labelLogout}",
                                                isDarkMode,
                                                Icon(
                                                  Icons.logout,
                                                  size: 22,
                                                ))
                                            /* DetailBox(heading: "Logout",
                                              subHeading: "",
                                              icon:
                                              Icons.logout,
                                              headingTextSize: 16,
                                              subHeadingTextSize: 12)*/

                                            ),
                                      ]),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  _buildCard(BuildContext context, String text, bool isDarkMode, Icon icon) {
    return Container(
      width: screenWidth * 0.7,
      padding: EdgeInsets.symmetric(
          vertical: isTablet ? 10 : 14.0, horizontal: isTablet ? 10 : 12.0),
      child: Row(
        children: [
          icon,
          SizedBox(
            width: 5,
          ),
          Text(text,
              style: TextStyle(
                fontSize: 15.0,
              )),
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    if (customerName == null ||
        customerName == "" ||
        userName == null ||
        userName == "") {
      setState(() {
        isLoading = true;
      });
    }
    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        _fetchDataFromPref();
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${Languages.of(context)?.labelNoInternetConnection}'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      String? retrievedToken = await Helper.getUserToken();
      print("Token $retrievedToken");
      if (mounted) {
        /*await Provider.of<MainViewModel>(context, listen: false)
            .profileScreenData("api/v1/app/customers/show_customer_details");*/
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getProfileResponse(context, apiResponse);
      }
    }
  }

  Future<void> _showLogOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Adjust the radius as needed
          ),
          insetPadding: EdgeInsets.zero,
          elevation: 5,
          titleTextStyle: TextStyle(
              fontSize: 20,
              color: isDarkMode ? Colors.white : AppColor.PRIMARY,
              fontWeight: FontWeight.bold),
          title: Center(
              child: Text(
            "${Languages.of(context)?.labelLogout}",
            style: TextStyle(fontSize: 20),
          )),
          content: IntrinsicHeight(
            child: Container(
              //height: screenHeight * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor),
                          child: Icon(
                            Icons.logout_outlined,
                            size: 55,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                          child: Text(
                        "${Languages.of(context)?.labelAreYouSureYouWantToLogout}",
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: screenWidth * 0.25,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.redAccent),
                          ),
                          child: Text("${Languages.of(context)?.labelNO}"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: screenWidth * 0.33,
                        child: TextButton(
                          child: Text("${Languages.of(context)?.labelYes}"),
                          onPressed: () {
                            Helper.clearAllSharedPreferences();
                            database.personDao.clearAllCustomerDetails();
                            database.dashboardTransactionDao
                                .clearAllTransactions();

                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/SignInScreen',
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[],
        );
      },
    );
  }

  void _fetchDataFromPref() async {
    Helper.getProfileDetails().then((profile) {
      setState(() {
        customerName = "${profile?.firstName} ${profile?.lastName}";
        userName = "${profile?.phoneNumber}";
        imageUrl = profile?.imageUrl.toString();
        isLoading = false;
        isUsernameRetrieved = true;
        dashBoardKycStatus = "${profile?.kycStatus}";
      });
    });
  }
}
