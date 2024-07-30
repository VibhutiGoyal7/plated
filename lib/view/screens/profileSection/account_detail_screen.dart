import 'package:Payrio/model/response/profileResponse.dart';
import 'package:Payrio/utils/Helper.dart';
import 'package:Payrio/view/component/detail_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/fetchKycDocResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/shimmer_card.dart';

class AccountDetailScreen extends StatefulWidget {
  @override
  _AccountDetailScreenState createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  var password;
  var phoneNumber;
  var userId;

  var isEmailVerified;
  var isPasswordVisible = false;
  bool isDarkMode = false;


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




  static const maxDuration = Duration(seconds: 2);

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  bool isInternetConnected = true;
  late VideoPlayerController videoPlayerController;
  String video = "";


  @override
  void initState() {
    super.initState();
    password = "";
    phoneNumber = "";
    userId = "";
    isEmailVerified = false;
    isPasswordVisible = false;
    setState(() {
      isLoading = true;
    });

    _fetchData();
    _fetchPasswordData();
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
        if (apiResponse.message == "Invalid access token") {
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
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            Languages.of(context)!.labelAccountDetails,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    DetailBox(
                      heading: Languages.of(context)!.enterPhoneNumber,
                      subHeading: phoneNumber.toString() ?? '',
                      icon: Icons.phone_android_outlined,
                      headingTextSize: 14,
                      subHeadingTextSize: 13,
                    ),

                    DetailBox(heading: Languages.of(context)!.labelUserId,
                      subHeading: userId.toString() ?? '',
                      icon: Icons.perm_identity_outlined,
                      headingTextSize: 14,
                      subHeadingTextSize: 13,
                    ),
                    _buildEmailVerification(
                        context: context,
                        isDarkMode: isDarkMode,
                        isEmailVerified: isEmailVerified,
                        onTap: () {
                          if (isEmailVerified == false) {
                            Navigator.pushNamed(context, '/VerifyEmail');
                          }
                        }),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Languages.of(context)!.labelUploadedDocs,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),

                    TabBar(
                      tabs: [
                        Tab(text: "Identity Proof"),
                        Tab(text: "Address Proof"),
                      ],
                      /*labelColor: AppColor.WHITE,
              unselectedLabelColor: AppColor.WHITE,
              indicatorColor: AppColor.WHITE,*/
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          IdentityProof(),
                          AddressProof()
                        ],
                      ),
                    ),
                    /*isInternetConnected && !isLoading
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
                              "${geoLocRejectedReason}"),
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
                        :
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ShimmerCard(),
                    ),*/

                  ],
                ),
              ),
              /* isLoading
                  ? Stack(
                children: [
                  // Block interaction
                  ModalBarrier(
                      dismissible: false,
                      color: Colors.black.withOpacity(0.3)),
                  // Loader indicator
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
                  : SizedBox(),*/
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildEmailVerification({
    required BuildContext context,
    required bool isEmailVerified,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEmailVerified
                            ? Languages.of(context)!.labelEmailVerified
                            : Languages.of(context)!.labelVerifyEmail,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      isEmailVerified
                          ?
                      Icon( Icons.verified_user , color: Colors.green,) : Icon( Icons.edit),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: isEmailVerified
                      ? Text(
                          Languages.of(context)!.labelEmailVerifiedContent,
                          style: TextStyle(
                            fontSize: 13.0,
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Text(
                                Languages.of(context)!.labelVerifyEmailContent,
                                style: TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBox({
    required BuildContext context,
    required String heading,
    required String subHeading,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(width: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  heading,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    //color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  subHeading.isEmpty ? "XXXXXXXXXX" : subHeading,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    /* color: value.isEmpty
                        ? Colors.grey
                        : isDarkMode ? Colors.white : Colors.black,
            */
                  ),
                ),
              ],
            ),
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
                                fontWeight: FontWeight.w600,
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


  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        phoneNumber = profileDetails?.phoneNumber;
        userId = profileDetails?.username;
        isEmailVerified = profileDetails?.isEmailVerified;
       // isLoading = false;
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


  Future<void> _fetchPasswordData() async {
    await Future.delayed(Duration(milliseconds: 2));
    password = await Helper.getPassword();
  }

  Widget IdentityProof() {
    return isInternetConnected && !isLoading
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
              "${geoLocRejectedReason}"),
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
        :
    Padding(
      padding: EdgeInsets.all(8),
      child: ShimmerCard(),
    );

  }

  Widget AddressProof() {
    return isInternetConnected && !isLoading
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
              "${geoLocRejectedReason}"),
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
        :
    Padding(
      padding: EdgeInsets.all(8),
      child: ShimmerCard(),
    );
  }
}

class IdentityProof extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

    );
  }
}

class AddressProof extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    );
  }
}
