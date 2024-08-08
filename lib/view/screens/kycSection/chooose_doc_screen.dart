import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/fetchKycDocResponse.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/toastMessage.dart';

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

  @override
  void initState() {
    super.initState();
    Helper.getCountry().then((country) {
      isCountryNameLoading = false;
      countryName = country;
    });
    _fetchDocData();

  }
/*
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data every time the screen becomes visible
    _fetchDocData();
  }*/

  Future<Widget> getDocData(
      BuildContext context, ApiResponse apiResponse) async {
    FetchKycDocResponse? mediaList = apiResponse.data as FetchKycDocResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
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


            isNationalIdAvailable = (mediaList?.nationalIdImage?.availableInCountry !=null ) ? mediaList?.nationalIdImage?.availableInCountry as bool : false;
            isPassportAvailable = mediaList?.passportImage?.availableInCountry!=null ? mediaList?.passportImage?.availableInCountry as bool :false;
            isDrivingLicenceAvailable = mediaList?.drivingLicenseImage?.availableInCountry!=null ? mediaList?.drivingLicenseImage?.availableInCountry as bool :false;
            isAddressLycAvailable = mediaList?.addressKycData?.availableInCountry!=null ? mediaList?.addressKycData?.availableInCountry as bool:false;
            isBankStatementAvailable = mediaList?.bankStatement?.availableInCountry!=null ? mediaList?.bankStatement?.availableInCountry as bool :false;
            isGeoLocAvailable = mediaList?.geolocation?.availableInCountry!=null ?  mediaList?.geolocation?.availableInCountry as bool:false;

            isLoading = false;

          });
        });
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("object");
        if (nonCapitalizeString("${apiResponse?.message}") == nonCapitalizeString("${Languages.of(context)?.labelInvalidAccessToken}")){
          SessionExpiredDialog.showDialogBox(context: context);}
        else{
          ToastComponent.showToast(context: context, message: apiResponse?.message);
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
    Navigator.pushReplacementNamed(
      context,
      "/BottomNav",
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/BottomNav');
            },
          ),
          title: Text(
            "Choose Your Document",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  child: Text(
                    'ISSUING COUNTRY',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
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
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  child: Text(
                    'ACCEPTED DOCUMENTS',
                    style: TextStyle(
                      fontSize: 16,
                    ),
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String verificationStatus = "";
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    if (nonCapitalizeString(status) == nonCapitalizeString("verified")) {
      verificationStatus = Languages.of(context)!.labelVerified;
      textColor = Colors.green;
    } else if (nonCapitalizeString(status) == nonCapitalizeString("rejected")) {
      verificationStatus = "Rejected";
      textColor = Colors.red;
    } else if (nonCapitalizeString(status) == nonCapitalizeString("in_progress")) {
      verificationStatus = Languages.of(context)!.labelInProgress;
      textColor = Colors.deepOrange;
    } else {
      verificationStatus = Languages.of(context)!.labelPending;
      textColor = Colors.orange;
    }
    return GestureDetector(
      onTap: () async {
        if (nonCapitalizeString(verificationStatus) == nonCapitalizeString("Pending") ||
            nonCapitalizeString(verificationStatus) == nonCapitalizeString("Rejected")) {
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
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: Card(
          child: isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.white38,
                  highlightColor: Colors.grey,
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the radius as needed
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
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
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              (nonCapitalizeString(status) == nonCapitalizeString("rejected"))
                                  ? rejectionReason
                                  : subtitle,
                              style: TextStyle(
                                color: (nonCapitalizeString(status) == nonCapitalizeString("rejected"))
                                    ? textColor
                                    : isDarkMode
                                        ? Colors.white
                                        : Colors.black,
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
                            fontSize: 12,
                            color: textColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
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
    }else {
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchKycDocData("/api/v1/app/customers/customer_uploaded_documents");
      ApiResponse apiResponse =
          Provider
              .of<MainViewModel>(context, listen: false)
              .response;
      getDocData(context, apiResponse);
    }
  }

  Future<void> _fetchCountryName() async {
    countryName = (await Helper.getCountry())!;
  }
}
