import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/db/BDPassDatabase.dart';
import '../../../model/db/dao.dart';
import '../../../model/response/fetchKycDocResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';

class ChooseDocScreen extends StatefulWidget {
  @override
  _ChooseDocScreenState createState() => _ChooseDocScreenState();
}

class _ChooseDocScreenState extends State<ChooseDocScreen> {
  bool isLoading = true;
  bool isCountryNameLoading = true;

  static const maxDuration = Duration(seconds: 2);

  final ConnectivityService _connectivityService = ConnectivityService();

  String? countryName = "";
  String? countryFlag = "";
  String? currencySymbol = "";

  String? nationalIdStatus;
  String? passportStatus;
  String? drivingLicenceStatus;
  String? kycVideoStatus;
  String? addressKycStatus;
  String? bankStatementStatus;
  String? geoLocStatus;

  String? nationalIdRejectedReason;
  String? passportRejectedReason;
  String? drivingLicenceRejectedReason;
  String? kycVideoRejectedReason;
  String? addressKycRejectedReason;
  String? bankStatementRejectedReason;
  String? geoLocRejectedReason;

  bool isNationalIdAvailable = false;
  bool isPassportAvailable = true;
  bool isDrivingLicenceAvailable = true;
  bool isKycVideoAvailable = false;
  bool isAddressLycAvailable = false;
  bool isBankStatementAvailable = false;
  bool isGeoLocAvailable = false;
  bool isDarkMode = false;
  late BDPassDatabase database;
  late CustomerDataDao customerDataDao;

  @override
  void initState() {
    super.initState();
    Helper.getCountry().then((country) {
      isCountryNameLoading = false;
      countryName = country;
    });
    intializeDatabase();

    _fetchDocData();
  }

  Future<void> intializeDatabase() async {
    database = await $FloorBDPassDatabase
        .databaseBuilder('payorio_database.db')
        .build();
    customerDataDao = database.personDao;

    /*Helper.getCountryImageUrl().then((flagUrl) async {
      countryFlag = flagUrl;
    });*/
  }

  Future<Widget> getDocData(
      BuildContext context, ApiResponse apiResponse) async {
    FetchKycDocResponse? mediaList = apiResponse.data as FetchKycDocResponse?;
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
        print("completed: ${mediaList?.nationalIdImage?.documentType}");

        print("passport ${mediaList?.passportImage?.verificationStatus}");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            //imageClicked = true;
            nationalIdStatus = mediaList?.nationalIdImage?.verificationStatus;
            passportStatus = mediaList?.passportImage?.verificationStatus;
            drivingLicenceStatus =
                mediaList?.drivingLicenseImage?.verificationStatus;
            addressKycStatus = mediaList?.addressKycData?.verificationStatus;
            bankStatementStatus = mediaList?.bankStatement?.verificationStatus;
            geoLocStatus = mediaList?.geolocation?.verificationStatus;

            nationalIdRejectedReason =
                mediaList?.nationalIdImage?.rejectionReason;
            passportRejectedReason = mediaList?.passportImage?.rejectionReason;
            drivingLicenceRejectedReason =
                mediaList?.drivingLicenseImage?.rejectionReason;
            addressKycRejectedReason =
                mediaList?.addressKycData?.rejectionReason;
            bankStatementRejectedReason =
                mediaList?.bankStatement?.rejectionReason;
            geoLocRejectedReason = mediaList?.geolocation?.rejectionReason;

            isNationalIdAvailable =
                (mediaList?.nationalIdImage?.availableInCountry != null)
                    ? mediaList?.nationalIdImage?.availableInCountry as bool
                    : false;
            isPassportAvailable =
                mediaList?.passportImage?.availableInCountry != null
                    ? mediaList?.passportImage?.availableInCountry as bool
                    : false;
            isDrivingLicenceAvailable =
                mediaList?.drivingLicenseImage?.availableInCountry != null
                    ? mediaList?.drivingLicenseImage?.availableInCountry as bool
                    : false;
            isAddressLycAvailable =
                mediaList?.addressKycData?.availableInCountry != null
                    ? mediaList?.addressKycData?.availableInCountry as bool
                    : false;
            isBankStatementAvailable =
                mediaList?.bankStatement?.availableInCountry != null
                    ? mediaList?.bankStatement?.availableInCountry as bool
                    : false;
            isGeoLocAvailable =
                mediaList?.geolocation?.availableInCountry != null
                    ? mediaList?.geolocation?.availableInCountry as bool
                    : false;

            isLoading = false;
          });
        });
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("object");
        if (nonCapitalizeString("${apiResponse?.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        }

        return Center(
            //child: Text('Please try again later!!!'),
            );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(context, "/BottomNav", arguments: 0);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = getIsTablet(context, screenWidth, screenHeight);
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (Platform.isIOS) {
            if (details.velocity.pixelsPerSecond.dx > 50) {
              if (isKeyboardOpen(context)) {
                hideKeyBoard();
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  "/BottomNav",
                  arguments: 0,
                );
              }
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 65,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/BottomNav', arguments: 0);
              },
            ),
            systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: AppColor.PRIMARY,
              statusBarIconBrightness:
                  Brightness.light, // Change icon brightness
            ),
            // title: Text(
            //   "Choose Your Document",
            //   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            // ),
          ),
          body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              image: !isDarkMode ? DecorationImage(
                image: AssetImage('assets/back_3.png'),
                // Replace with your image asset path
                fit: BoxFit
                    .cover, // This makes the image cover the entire container
              ) : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      'Proof of\nResidency',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10.0),
                      child: Row(
                        children: [
                          Text(
                            'Nationality',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 72,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColor.DARK_CARD_COLOR
                            : AppColor.LIGHT_CARD_COLOR,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                              padding: EdgeInsets.all(6),
                              height: isTablet ? 45 : 45,
                              width: isTablet ? 45 : 55,
                              child: countryFlag == ""
                                  ? Container(
                                      padding: EdgeInsets.all(1),
                                      height: isTablet ? 45 : 45,
                                      width: isTablet ? 45 : 55,
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.white38,
                                        highlightColor: Colors.grey,
                                        child: Container(
                                          height: isTablet ? 45 : 45,
                                          width: isTablet ? 45 : 55,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(80),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ))
                                  : Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context).cardColor,
                                            width: 0.01),
                                        color: Colors.white,
                                      ),
                                      child: ClipRRect(
                                        child: Image.network(
                                          "${countryFlag}",
                                          height: isTablet ? 45 : 45,
                                          width: isTablet ? 45 : 55,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Container(
                                              height: isTablet ? 25 : 25,
                                              width: isTablet ? 25 : 25,
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
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Shimmer.fromColors(
                                                baseColor: Colors.white38,
                                                highlightColor: Colors.grey,
                                                child: Container(
                                                  height: isTablet ? 45 : 45,
                                                  width: isTablet ? 45 : 55,
                                                  color: Colors.white,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    )),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: isCountryNameLoading
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.white38,
                                      highlightColor: Colors.grey,
                                      child: Container(
                                        width: 60,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: Colors.white38,
                                          borderRadius: BorderRadius.circular(
                                              8.0), // Adjust the radius as needed
                                        ),
                                      ),
                                    )
                                  : Text(
                                      "${countryName}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verification Method',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '(Please verify at-least one method)',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    if (isPassportAvailable)
                      _buildDocumentOption(
                          context,
                          Languages.of(context)!.labelPassport,
                          Languages.of(context)!.labelPhotoPage,
                          'passport',
                          "assets/passport.png",
                          "${passportStatus}",
                          "${passportRejectedReason}"),
                    if (isDrivingLicenceAvailable)
                      _buildDocumentOption(
                          context,
                          Languages.of(context)!.labelDrivingLicence,
                          Languages.of(context)!.labelFrontNBack,
                          'driving_licence',
                          "assets/license.png",
                          "${drivingLicenceStatus}",
                          "${drivingLicenceRejectedReason}"),
                    if (isNationalIdAvailable)
                      _buildDocumentOption(
                          context,
                          Languages.of(context)!.labelNationalId,
                          Languages.of(context)!.labelFrontNBack,
                          'national_id',
                          "assets/id_card.png",
                          "${nationalIdStatus}",
                          "${nationalIdRejectedReason}"),
                    if (isAddressLycAvailable)
                      _buildDocumentOption(
                          context,
                          "Address KYC",
                          'Front ',
                          'address_kyc',
                          "assets/address.png",
                          "${addressKycStatus}",
                          "${addressKycRejectedReason}"),
                    if (isBankStatementAvailable)
                      _buildDocumentOption(
                          context,
                          "Bank Statement",
                          'Front ',
                          'bank_statement',
                          "assets/bank_statement.png",
                          "${bankStatementStatus}",
                          "${bankStatementRejectedReason}"),
                    if (isGeoLocAvailable)
                      _buildDocumentOption(
                          context,
                          "Geolocation KYC",
                          'Front ',
                          'geolocation_kyc',
                          "assets/geo_Location.jpg",
                          "${geoLocStatus}",
                          "${geoLocRejectedReason}"),
                    /*if (isKycVideoAvailable)
                      _buildDocumentOption(
                          context,
                          Languages.of(context)!.labelVideoVerification,
                          'Front ',
                          '/VideoKycScreen',
                          'video_kyc_clip',
                          "assets/video.png",
                          "${kycVideoStatus}",
                          "${kycVideoRejectedReason}"),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentOption(
      BuildContext context,
      String title,
      String subtitle,
      String data,
      String icon,
      String status,
      String rejectionReason) {
    String verificationStatus = "";
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    if (nonCapitalizeString(status) == nonCapitalizeString("verified")) {
      verificationStatus = Languages.of(context)!.labelVerified;
      textColor = Colors.green;
    } else if (nonCapitalizeString(status) == nonCapitalizeString("rejected")) {
      verificationStatus = "Click to upload";
      textColor = Colors.red;
    } else if (nonCapitalizeString(status) ==
        nonCapitalizeString("in_progress")) {
      verificationStatus = Languages.of(context)!.labelPending;
      textColor = Colors.deepOrange;
    } else {
      verificationStatus =
          "Click to Upload"; //Languages.of(context)!.labelPending;
      textColor = Colors.orange;
    }
    return GestureDetector(
      onTap: () async {
        if (nonCapitalizeString(verificationStatus) ==
                nonCapitalizeString("Click to Upload") ||
            nonCapitalizeString(verificationStatus) ==
                nonCapitalizeString("Rejected")) {
          if (await checkPermissionStatus()) {
            Navigator.pushReplacementNamed(context, "/DocImageScreen",
                arguments: "${data}");
          } else {
            Navigator.pushNamed(context, "/CameraAccessScreen",
                arguments: "${data}");
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        margin: const EdgeInsets.only(top: 2.0, bottom: 5.0),
        child: Card(
          elevation: 0,
          child: isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.white38,
                  highlightColor: Colors.grey,
                  child: Container(
                    width: double.infinity,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the radius as needed
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColor.DARK_CARD_COLOR
                        : AppColor.LIGHT_CARD_COLOR,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 14),
                        child: Image(
                          alignment: Alignment.topLeft,
                          width: 25,
                          image: AssetImage(icon),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                (nonCapitalizeString(status) ==
                                        nonCapitalizeString("rejected"))
                                    ? rejectionReason
                                    : subtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: (nonCapitalizeString(status) ==
                                          nonCapitalizeString("rejected"))
                                      ? textColor
                                      : isDarkMode
                                          ? Colors.white
                                          : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 6),
                        child: Text(
                          verificationStatus,
                          style: TextStyle(
                              fontSize: 11,
                              color: textColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<bool> checkPermissionStatus() async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    print(isCameraGranted);
    return await isCameraGranted;
  }

  Future<void> _fetchDocData() async {
    await Future.delayed(Duration(milliseconds: 2));
    setState(() {
      isLoading = true;
    });

    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
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
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchKycDocData("/api/v1/app/customers/customer_uploaded_documents");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getDocData(context, apiResponse);
    }
  }

  Future<void> _fetchCountryName() async {
    countryName = (await Helper.getCountry())!;
  }
}
