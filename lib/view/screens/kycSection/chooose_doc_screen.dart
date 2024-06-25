import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/fetchKycDocResponse.dart';
import '../../../view_model/media_view_model.dart';

class ChooseDocScreen extends StatefulWidget {
  @override
  _ChooseDocScreenState createState() => _ChooseDocScreenState();
}

class _ChooseDocScreenState extends State<ChooseDocScreen> {
  bool isNationalIdUploaded = false;
  bool isPassportUploaded = false;
  bool isDrivingLicenceUploaded = false;
  bool isKycVideoUploaded = false;

  String? nationalIdStatus;

  String? passportStatus;

  String? drivingLicenceStatus;

  String? kycVideoStatus;

  @override
  void initState() {
    super.initState();
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

            if (mediaList?.nationalIdImage?.userId != null) {
              isNationalIdUploaded = true;
              nationalIdStatus = mediaList?.nationalIdImage?.verificationStatus;
            }
            ;
            if (mediaList?.passportImage?.userId != null) {
              isPassportUploaded = true;
              passportStatus = mediaList?.passportImage?.verificationStatus;
            }
            if (mediaList?.drivingLicenseImage?.userId != null) {
              isDrivingLicenceUploaded = true;
              drivingLicenceStatus =
                  mediaList?.drivingLicenseImage?.verificationStatus;
            }
            if (mediaList?.videoClipUrl?.userId != null) {
              isKycVideoUploaded = true;
              kycVideoStatus = mediaList?.videoClipUrl?.verificationStatus;
            }
          });
        });
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
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
                        child: Text(
                          'India',
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
              _buildDocumentOption(
                  context,
                  'Passport',
                  'Photo page',
                  '/CameraAccessScreen',
                  'passport',
                  "assets/passport.png",
                  isPassportUploaded,
                  "${passportStatus}"),
              _buildDocumentOption(
                  context,
                  'Driving License',
                  'Front and Back',
                  '/CameraAccessScreen',
                  'national_id',
                  "assets/license.png",
                  isDrivingLicenceUploaded,
                  "${drivingLicenceStatus}"),
              _buildDocumentOption(
                  context,
                  'National Identity Card',
                  'Front and Back',
                  '/CameraAccessScreen',
                  'driving_licence',
                  "assets/id_card.png",
                  isNationalIdUploaded,
                  "${nationalIdStatus}"),
              _buildDocumentOption(
                  context,
                  'Video Verification',
                  'Front ',
                  '/VideoKycScreen',
                  'video',
                  "assets/video.png",
                  isKycVideoUploaded,
                  "${kycVideoStatus}"),
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
      bool imageUploaded,
      String status) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String verificationStatus = "";
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    if (imageUploaded && status == "pending") {
      verificationStatus = "In Progress";
      textColor = Colors.deepOrange;
    } else if (imageUploaded) {
      verificationStatus = status;
      if (verificationStatus == "verified") {
        textColor = Colors.green;
      } else if (verificationStatus == "rejected") {
        textColor = Colors.red;
      }
    } else {
      verificationStatus = "Pending";
      textColor = Colors.orange;
    }
    return GestureDetector(
      onTap: () async {
        if (!(imageUploaded && status == "pending")) {
          if (await checkPermissionStatus()) {
            Navigator.pushNamed(context, "/DocImageScreen",
                arguments: "${data}");
          } else {
            Navigator.pushNamed(context, route, arguments: "${data}");
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: Card(
          child: Row(
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
                        subtitle,
                        style: TextStyle(),
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
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }
    final permission = Permission.camera;
    PermissionStatus status = await permission.status;
    print(status);
    if (status.isDenied) {
      // Handle the case when permission is permanently denied
      openAppSettings();
    }
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
}
