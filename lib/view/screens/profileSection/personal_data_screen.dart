import 'package:Payrio/model/response/fetchKycDocResponse.dart';
import 'package:Payrio/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/profileResponse.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/shimmer_card.dart';

class PersonalDataScreen extends StatefulWidget {
  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  bool isLoading = true;
  bool isInternetConnected = true;
  late VideoPlayerController videoPlayerController;
  String video = "";

  bool isDarkMode = false;

  var firstName;
  var lastName;
  var userName;
  var documentNumber;
  var dob;
  var email;

  String? nationalIdImg;
  String? passportImg;
  String? drivingLicenseImg;
  String? kycVideo;
  String? addressKycImg;
  String? geoLocImg;
  String? bankStatementImg;

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
  bool isPassportAvailable = false;
  bool isDrivingLicenceAvailable = false;
  bool isKycVideoAvailable = false;
  bool isAddressLycAvailable = false;
  bool isBankStatementAvailable = false;
  bool isGeoLocAvailable = false;

  bool mExpanded = false;
  String mSelectedText = "";
  final List<String> mCities = ["Aadhar", "PanCard"];
  final TextEditingController documentNumberController =
      TextEditingController();

  static const maxDuration = Duration(seconds: 2);
  bool isDataLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    firstName = "";
    lastName = "";
    userName = "";
    dob = "";
    email = "";
    nationalIdImg = "";
    passportImg = "";
    drivingLicenseImg = "";
    isDataLoading = true;
    _fetchData();
    _fetchDocData();
  }

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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print("completed: ${mediaList?.nationalIdImage?.documentType}");
          setState(() {
            //imageClicked = true;
            nationalIdImg = mediaList?.nationalIdImage?.kycDocsImageUrl;
            passportImg = mediaList?.passportImage?.kycDocsImageUrl;
            drivingLicenseImg = mediaList?.drivingLicenseImage?.kycDocsImageUrl;
            bankStatementImg = mediaList?.bankStatement?.kycDocsImageUrl;
            addressKycImg = mediaList?.addressKycData?.kycDocsImageUrl;
            geoLocImg = mediaList?.geolocation?.kycDocsImageUrl;
            kycVideo = mediaList?.videoClipUrl?.kycDocsImageUrl;

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
            isKycVideoAvailable =
                mediaList?.videoClipUrl?.availableInCountry != null
                    ? mediaList?.videoClipUrl?.availableInCountry as bool
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
        if (apiResponse?.message == "Invalid access token") {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Try again later!'),
              duration: maxDuration,
            ),
          );
        }
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
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Languages.of(context)!.labelPersonalData,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProfileSection(
                Languages.of(context)!.labelFirstname, firstName),
            buildProfileSection(Languages.of(context)!.labelLastname, lastName),
            buildProfileSection(Languages.of(context)!.labelEmail, email),
            buildProfileSection(Languages.of(context)!.labelUsername, userName),
            buildBirthdateSection(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Languages.of(context)!.labelUploadedDocs,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            isInternetConnected && !isLoading
                ? Column(
                    children: [
                      if (isPassportAvailable)
                        _buildDocumentOption(
                            context,
                            Languages.of(context)!.labelPassport,
                            Languages.of(context)!.labelPhotoPage,
                            '/DocImageScreen',
                            'passport',
                            "${passportImg}",
                            "assets/passport.png",
                            "${passportStatus}",
                            "${passportRejectedReason}"),
                      if (isDrivingLicenceAvailable)
                        _buildDocumentOption(
                            context,
                            Languages.of(context)!.labelDrivingLicence,
                            Languages.of(context)!.labelFrontNBack,
                            '/DocImageScreen',
                            'driving_licence',
                            "${drivingLicenseImg}",
                            "assets/license.png",
                            "${drivingLicenceStatus}",
                            "${drivingLicenceRejectedReason}"),
                      if (isNationalIdAvailable)
                        _buildDocumentOption(
                            context,
                            Languages.of(context)!.labelNationalId,
                            Languages.of(context)!.labelFrontNBack,
                            '/DocImageScreen',
                            'national_id',
                            "${nationalIdImg}",
                            "assets/id_card.png",
                            "${nationalIdStatus}",
                            "${nationalIdRejectedReason}"),
                      if (isAddressLycAvailable)
                        _buildDocumentOption(
                            context,
                            "Address KYC",
                            'Front ',
                            '/DocImageScreen',
                            'address_kyc',
                            "${addressKycImg}",
                            "assets/address.png",
                            "${addressKycStatus}",
                            "${addressKycRejectedReason}"),
                      if (isBankStatementAvailable)
                        _buildDocumentOption(
                            context,
                            "Bank Statement",
                            'Front ',
                            '/DocImageScreen',
                            'bank_statement',
                            "${bankStatementImg}",
                            "assets/bank_statement.png",
                            "${bankStatementStatus}",
                            "${bankStatementRejectedReason}"),
                      if (isGeoLocAvailable)
                        _buildDocumentOption(
                          context,
                          "Geolocation KYC",
                          'Front ',
                          '/DocImageScreen',
                          'geolocation_kyc',
                          "${geoLocImg}",
                          "assets/geo_Location.jpg",
                          "${geoLocStatus}",
                          "${geoLocRejectedReason}",
                        ),
                      if (isKycVideoAvailable)
                        _buildDocumentOption(
                            context,
                            Languages.of(context)!.labelVideoVerification,
                            'Front ',
                            '/VideoKycScreen',
                            'video_kyc_clip',
                            "${kycVideo}",
                            "assets/video.png",
                            "${kycVideoStatus}",
                            "${kycVideoRejectedReason}"),
                    ],
                  )
                : ShimmerCard(),

            // buildDocumentDropdown(),
            // buildDocumentNumberSection(),
          ],
        ),
      ),
    );
  }

  Widget buildProfileSection(String label, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBirthdateSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Languages.of(context)!.labelBirthdate,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  dob,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),

            /*   GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate:DateTime.now().subtract(Duration(days: 365*18)),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime.now().subtract(Duration(days: 365*18)),
                      //DateTime.now() - not to allow to choose before today.
                      helpText: "Date Of Birth",
                      confirmText: "Confirm",
                      errorFormatText: 'Enter valid date',
                      errorInvalidText: 'Enter date in valid range',
                      builder: (context, child) {
                        return Theme(
                          data: isDarkMode
                              ? ThemeData.dark()
                              : ThemeData
                                  .light(), // This will change to light theme.
                          child: child!,
                        );
                      });

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      dob = formattedDate;
                      */ /*_dateController.text =
                          formattedDate;*/ /* //set output date to TextField value.
                    });
                  } else {}
                },
                child: Icon(Icons.calendar_today)),*/
          ],
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
      String image,
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
    } else if (status == "in_progress") {
      verificationStatus = Languages.of(context)!.labelInProgress;
      textColor = Colors.deepOrange;
    } else {
      verificationStatus = Languages.of(context)!.labelPending;
      textColor = Colors.orange;
    }
    return GestureDetector(
      onTap: () async {
        if (verificationStatus == "Pending") {
          if (await checkPermissionStatus()) {
            Navigator.pushReplacementNamed(context, route,
                arguments: "${data}");
          } else {
            Navigator.pushNamed(context, "/CameraAccessScreen",
                arguments: "${data}");
          }
        } else {
          if (title != Languages.of(context)!.labelVideoVerification) {
            _showModal(context, image, false, verificationStatus, route, data,
                rejectionReason);
          }
        }

        /*if (verificationStatus == "Pending" ||
            verificationStatus == "Rejected") {
          if (await checkPermissionStatus()) {
            Navigator.pushReplacementNamed(context, route,
                arguments: "${data}");
          } else {
            Navigator.pushNamed(context, "/CameraAccessScreen",
                arguments: "${data}");
          }
        }*/
      },
      child: Card(
        child: isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.white38,
                highlightColor: Colors.grey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18),
                  child: Container(
                    width: double.infinity,
                    //height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the radius as needed
                    ),
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Container(
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
                                (status == "rejected")
                                    ? rejectionReason
                                    : subtitle,
                                style: TextStyle(
                                  color: (status == "rejected")
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
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  /*Widget _buildDocumentOption( BuildContext context,
      String title,
      String data,
      String icon,
      String status,
      String image,
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
      onTap: () {
        if ( title != Languages.of(context)!.labelVideoVerification) {
          _showModal(context, image, false);
        }*/ /*else {
          print(video);
          videoPlayerController = VideoPlayerController.network(
            video, // Replace with your video URL
          )..initialize().then((_) {
            setState(() {});  // Ensure the first frame is shown after the video is initialized
          });
          _showModal(context,  image, true);
        }*/ /*
      },
      child: Container(
        width: double.infinity,
        child: Card(
          child: isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.white38,
                  highlightColor: Colors.grey,
                  child: Container(
                    width: double.infinity,
                    height: 70,
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
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Image(
                        alignment: Alignment.topLeft,
                        width: 25,
                        image: AssetImage(icon),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                          ),
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
  }*/

  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        firstName = profileDetails?.firstName;
        lastName = profileDetails?.lastName;
        userName = profileDetails?.username;
        dob = profileDetails?.dob;
        email = profileDetails?.email;
        isDataLoading = false;
      });
    });
    return profileDetails;
  }

  Future<void> _fetchDocData() async {
    setState(() {
      isLoading = true;
    });
    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        isInternetConnected = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No internet connection'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchKycDocData("/api/v1/app/customers/customer_uploaded_documents");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getDocData(context, apiResponse);
    }
  }

  void _showModal(BuildContext context, String? image, bool isVideo,
      String status, String route, String data, String rejectionReason) {
    if (isVideo) {
      setState(() {
        video = image as String;
      });
    }

    Color textColor = isDarkMode ? Colors.white : Colors.black;
    if (status == "Verified") {
      textColor = Colors.green;
    } else if (status == "Rejected") {
      textColor = Colors.red;
    } else if (status == "In Progress") {
      textColor = Colors.deepOrange;
    } else {
      textColor = Colors.orange;
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: Border.all(),
              scrollable: false,
              insetPadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.78,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            child: (!isVideo)
                                ? (image != "" || image!.isNotEmpty)
                                    ? ClipRRect(
                                        child: Image.network(
                                        image as String,
                                        fit: BoxFit.fill,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.72,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: Colors.grey,
                                              ),
                                            );
                                          }
                                        },
                                      ))
                                    : Text(Languages.of(context)!
                                        .labelStatusPending)
                                : videoPlayerController != null &&
                                        videoPlayerController
                                            .value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio: videoPlayerController
                                            .value.aspectRatio,
                                        child:
                                            VideoPlayer(videoPlayerController),
                                      )
                                    : Text(Languages.of(context)!
                                        .labelStatusPending)),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: double.infinity,
                            color: textColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            child: Text(
                              (status == "Rejected")
                                  ? "${status} - ${rejectionReason}"
                                  : "${status}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ))),
                            )),
                      ],
                    ),
                    status == "Rejected"
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () async {
                                if (await checkPermissionStatus()) {
                                  Navigator.pushReplacementNamed(context, route,
                                      arguments: "${data}");
                                } else {
                                  Navigator.pushNamed(
                                      context, "/CameraAccessScreen",
                                      arguments: "${data}");
                                }
                              },
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: double.infinity,
                                  color: AppColor.PRIMARY,
                                  //margin: EdgeInsets.symmetric(horizontal: 5),
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    "Re-upload",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> checkPermissionStatus() async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    print(isCameraGranted);
    return await isCameraGranted;
  }
}
