import 'package:flutter/material.dart';
import 'package:Payrio/model/response/fetchKycDocResponse.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/profileResponse.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/media_view_model.dart';
import '../../component/session_expired_dialog.dart';

class PersonalDataScreen extends StatefulWidget {
  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  var firstName;
  var lastName;
  var userName;
  var documentNumber;
  var dob;

  String? nationalIdImg;
  String? passportImg;
  String? drivingLicenseImg;
  String? kycVideo;

  bool isNationalIdUploaded = false;
  bool isPassportUploaded = false;
  bool isDrivingLicenceUploaded = false;
  bool isKycVideoUploaded = false;

  String? nationalIdStatus;
  String? passportStatus;
  String? drivingLicenceStatus;
  String? kycVideoStatus;


  bool mExpanded = false;
  String mSelectedText = "";
  final List<String> mCities = ["Aadhar", "PanCard"];
  final TextEditingController documentNumberController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    firstName = "";
    lastName = "";
    userName = "";
    dob = "";
    nationalIdImg = "" ;
    passportImg="";
    drivingLicenseImg="";
    _fetchData();
    _fetchDocData();
  }

  Future<Widget> getMediaWidget(BuildContext context,
      ApiResponse apiResponse) async {
    FetchKycDocResponse? mediaList = apiResponse.data as FetchKycDocResponse?;
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

            if (mediaList?.nationalIdImage?.userId != null) {
              isNationalIdUploaded = true;
              nationalIdStatus = mediaList?.nationalIdImage?.verificationStatus;
            };
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

        if(mediaList?.message== "Invalid access token")
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
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;

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
            buildProfileSection(Languages.of(context)!.labelUsername, userName),
            buildBirthdateSection(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(Languages.of(context)!.labelUploadedDocs,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            _buildDocumentOption(
                context,
                Languages.of(context)!.labelPassport,
                Languages.of(context)!.labelPhotoPage,
                '/CameraAccessScreen',
                'passport',
                "assets/passport.png",
                passportImg,
                isPassportUploaded,
                "${passportStatus}"),
            _buildDocumentOption(
                context,
                Languages.of(context)!.labelDrivingLicence,
                Languages.of(context)!.labelFrontNBack,
                '/CameraAccessScreen',
                'driving_licence',
                "assets/license.png",
                drivingLicenseImg,
                isDrivingLicenceUploaded,
                "${drivingLicenceStatus}"
            ),
            _buildDocumentOption(
                context,
              Languages.of(context)!.labelNationalId,
              Languages.of(context)!.labelFrontNBack,
                '/CameraAccessScreen',
              'national_id',
              "assets/id_card.png",
              nationalIdImg,
                isNationalIdUploaded,
                "${nationalIdStatus}",

            ),
            _buildDocumentOption(
                context,
              Languages.of(context)!.labelVideoVerification,
                'Front ',
                '/VideoKycScreen',
                'video',
                "assets/video.png",
              kycVideo,
                isKycVideoUploaded,
                "${kycVideoStatus}",

            ),
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Languages.of(context)!.labelBirthdate,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.calendar_today),
        ],
      ),
    );
  }

/*
  Widget buildDocumentSection(String docName, String image, double screenHeight, double screenWidth){
    return Padding(padding: EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${docName} : "),
        (image!=""|| image.isNotEmpty ) ?ClipRRect(
          child: Image.network(image ,
              height: screenHeight * 0.2,
              fit: BoxFit.fill),
        ) : Text("Status Pending")
      ],
    ));
  }
  Widget buildDocumentDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            readOnly: true,
            controller: TextEditingController(text: mSelectedText),
            decoration: InputDecoration(
              labelText: Languages.of(context)!.labelChooseDoc,
              suffixIcon: IconButton(
                icon: Icon(
                    mExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    mExpanded = !mExpanded;
                  });
                },
              ),
            ),
          ),
          if (mExpanded)
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: mCities.map((city) {
                  return ListTile(
                    title: Text(city),
                    onTap: () {
                      setState(() {
                        mSelectedText = city;
                        mExpanded = false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildDocumentNumberSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Languages.of(context)!.labelDocNo,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextField(
            controller: documentNumberController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            onChanged: (value) {
              setState(() {
                documentNumber = value;
              });
            },
          ),
        ],
      ),
    );
  }
*/

  Widget _buildDocumentOption(BuildContext context, String title,
      String subtitle, String route, String data, String icon, String? image,
      bool imageUploaded, String status) {
    bool isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    String verificationStatus = "";
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    if (imageUploaded && status == "pending") {
      verificationStatus = Languages.of(context)!.labelInProgress;
      textColor = Colors.deepOrange;
    } else if (imageUploaded) {
      verificationStatus = status;
      if (verificationStatus == "verified") {
        textColor = Colors.green;
      } else if (verificationStatus == "rejected") {
        textColor = Colors.red;
      }
    }
    else {
      verificationStatus = Languages.of(context)!.labelPending;
      textColor = Colors.orange;
    }
    return GestureDetector(
      onTap: () {
        if (imageUploaded && title != Languages.of(context)!.labelVideoVerification) {
          _showModal(context, image);
        }
      },
      child: Container(
        width: double.infinity,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        firstName = profileDetails?.firstName;
        lastName = profileDetails?.lastName;
        userName = profileDetails?.username;
        dob = profileDetails?.dob;
      });
    });
    return profileDetails;
  }

  Future<void> _fetchDocData() async {
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MediaViewModel>(context, listen: false)
        .fetchKycDocData(
        "/api/v1/app/customers/customer_uploaded_documents");
    ApiResponse apiResponse =
        Provider.of<MediaViewModel>(context, listen: false).response;
    getMediaWidget(context, apiResponse);
  }

  void _showModal(BuildContext context, String? image) {
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
              contentPadding: EdgeInsets.symmetric(horizontal: 0  , vertical: 0),
                content:
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              child: (image != "" || image!.isNotEmpty) ? ClipRRect(
                                child: Image.network(image as String,
                                    fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.white30,
                                      highlightColor: Colors.grey,
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.5,
                                        color: Colors.grey,
                                      ),
                                    );

                                  }
                                },
                                )
                              ) : Text(Languages.of(context)!.labelStatusPending)
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                                      child: Icon(Icons.close ,color: Colors.white70,))),
                            )
                          )
                        ],
                      ),
                    ],
                  ),
                ),
            );
          },
        );
      },
    );
  }
}
