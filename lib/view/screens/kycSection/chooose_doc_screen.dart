import 'package:flutter/material.dart';
import 'package:Payrio/theme/AppTheme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/fetchKycDocResponse.dart';
import '../../../model/response/profileResponse.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/media_view_model.dart';
import '../../component/session_expired_dialog.dart';

class ChooseDocScreen extends StatefulWidget {
  @override
  _ChooseDocScreenState createState() => _ChooseDocScreenState();
}

class _ChooseDocScreenState extends State<ChooseDocScreen> {
  bool isLoading = true;
  bool isCountryNameLoading = true;

  String countryName = "";

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
  bool isPassportAvailable= true;
  bool isDrivingLicenceAvailable= true;
  bool isKycVideoAvailable= false;
  bool isAddressLycAvailable= false;
  bool isBankStatementAvailable= false;
  bool isGeoLocAvailable= false;

  @override
  void initState() {
    super.initState();
    _fetchDocData();
    _fetchCountryName();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data every time the screen becomes visible
    _fetchDocData();
  }

  Future<Widget> getMediaWidget(
      BuildContext context, ApiResponse apiResponse) async {
    FetchKycDocResponse? mediaList = apiResponse.data as FetchKycDocResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print("completed: ${mediaList?.nationalIdImage?.documentType}");
          setState(() {
            //imageClicked = true;
            nationalIdStatus = mediaList?.nationalIdImage?.verificationStatus;
            passportStatus = mediaList?.passportImage?.verificationStatus;
            drivingLicenceStatus =
                mediaList?.drivingLicenseImage?.verificationStatus;
            kycVideoStatus = mediaList?.videoClipUrl?.verificationStatus;
            addressKycStatus = mediaList?.addressKycData?.verificationStatus;
            bankStatementStatus = mediaList?.bankStatement?.verificationStatus;
            geoLocStatus = mediaList?.geolocation?.verificationStatus;

            nationalIdRejectedReason =
                mediaList?.nationalIdImage?.rejectionReason;
            passportRejectedReason = mediaList?.passportImage?.rejectionReason;
            drivingLicenceRejectedReason =
                mediaList?.drivingLicenseImage?.rejectionReason;
            kycVideoRejectedReason = mediaList?.videoClipUrl?.rejectionReason;
            addressKycRejectedReason =
                mediaList?.addressKycData?.rejectionReason;
            bankStatementRejectedReason =
                mediaList?.bankStatement?.rejectionReason;
            geoLocRejectedReason = mediaList?.geolocation?.rejectionReason;


            isNationalIdAvailable = mediaList?.nationalIdImage?.availableInCountry as bool;
            isPassportAvailable = mediaList?.passportImage?.availableInCountry as bool;
            isDrivingLicenceAvailable = mediaList?.drivingLicenseImage?.availableInCountry as bool;
            isKycVideoAvailable = mediaList?.videoClipUrl?.availableInCountry as bool;
            isAddressLycAvailable = mediaList?.addressKycData?.availableInCountry as bool;
            isBankStatementAvailable = mediaList?.bankStatement?.availableInCountry as bool;
            isGeoLocAvailable = mediaList?.geolocation?.availableInCountry as bool;

            isLoading = false;

          });
        });
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (mediaList?.message == "Invalid access token")
          SessionExpiredDialog.showDialogBox(context: context);
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Choose Your Document",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                            :  Text(
                          countryName,
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
              if(isPassportAvailable)
                _buildDocumentOption(
                  context,
                  Languages.of(context)!.labelPassport,
                  Languages.of(context)!.labelPhotoPage,
                  '/DocImageScreen',
                  'passport',
                  "assets/passport.png",
                  "${passportStatus}",
                    "${passportRejectedReason}"),
              if(isDrivingLicenceAvailable)
                _buildDocumentOption(
                  context,
                  Languages.of(context)!.labelDrivingLicence,
                  Languages.of(context)!.labelFrontNBack,
                  '/DocImageScreen',
                  'driving_licence',
                  "assets/license.png",
                  "${drivingLicenceStatus}",
                    "${drivingLicenceRejectedReason}"),
              if(isNationalIdAvailable)
                _buildDocumentOption(
                  context,
                  Languages.of(context)!.labelNationalId,
                  Languages.of(context)!.labelFrontNBack,
                  '/DocImageScreen',
                  'national_id',
                  "assets/id_card.png",
                  "${nationalIdStatus}",
                    "${nationalIdRejectedReason}"),
              if(isAddressLycAvailable)
                _buildDocumentOption(
                  context,
                  "Address KYC",
                  'Front ',
                  '/DocImageScreen',
                  'address_kyc',
                  "assets/address.png",
                  "${addressKycStatus}",
                    "${addressKycRejectedReason}"),
              if(isBankStatementAvailable)
                _buildDocumentOption(
                  context,
                  "Bank Statement",
                  'Front ',
                  '/DocImageScreen',
                  'bank_statement',
                  "assets/bank_statement.png",
                  "${bankStatementStatus}",
                    "${bankStatementRejectedReason}"),
              if(isGeoLocAvailable)
                _buildDocumentOption(
                  context,
                  "Geolocation KYC",
                  'Front ',
                  '/DocImageScreen',
                  'geolocation_kyc',
                  "assets/geo_Location.jpg",
                  "${geoLocStatus}",
                    "${geoLocRejectedReason}"),
              if (isKycVideoAvailable)
                _buildDocumentOption(
                  context,
                  Languages.of(context)!.labelVideoVerification,
                  'Front ',
                  '/VideoKycScreen',
                  'video_kyc_clip',
                  "assets/video.png",
                  "${kycVideoStatus}",
                "${kycVideoRejectedReason}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentOption(
      BuildContext context,
      String title,
      String subtitle,
      String route,
      String data,
      String icon,
      String status,
      String rejectionReason) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String verificationStatus = "";
    Color textColor = isDarkMode ? Colors.white : Colors.black;

      if (status == "verified") {
        verificationStatus = Languages.of(context)!.labelVerified;
        textColor = Colors.green;
      } else if (status == "rejected") {
        verificationStatus = "Rejected";
        textColor = Colors.red;
      }else if(status == "in_progress"){
        verificationStatus = Languages.of(context)!.labelInProgress;
        textColor = Colors.deepOrange;
      } else {
      verificationStatus = Languages.of(context)!.labelPending;
      textColor = Colors.orange;
    }
    return GestureDetector(
      onTap: () async {
        if (verificationStatus == "Pending" || verificationStatus =="In Progress") {
          if (await checkPermissionStatus()) {
            Navigator.pushReplacementNamed(context, route,
                arguments: "${data}");
          } else {
            Navigator.pushNamed(context, "/CameraAccessScreen", arguments: "${data}");
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: Card(
          child:isLoading
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
                        (status == "rejected") ? rejectionReason : subtitle,
                        style: TextStyle(
                          color: (status == "rejected") ? textColor: isDarkMode? Colors.white: Colors.black,
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
                      fontWeight: FontWeight.bold),
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
    await Provider.of<MediaViewModel>(context, listen: false)
        .fetchKycDocData("/api/v1/app/customers/customer_uploaded_documents");
    ApiResponse apiResponse =
        Provider.of<MediaViewModel>(context, listen: false).response;
    getMediaWidget(context, apiResponse);
  }

  Future<void> _fetchCountryName() async{
    countryName = (await Helper.getCountry())!;
  }
}
