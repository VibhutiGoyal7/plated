import 'dart:io';

import 'package:flutter/material.dart';
import 'package:payrio/model/response/fetchKycDocResponse.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/profileResponse.dart';
import '../../../model/response/uploadKycResponse.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/media_view_model.dart';

class PersonalDataScreen extends StatefulWidget {
  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  var firstName;

  var lastName;

  var documentNumber;
  var dob;

  String? nationalIdImg;
  String? passportImg;
  String? drivingLicenseImg;


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
    dob = "";
    documentNumber = "";
    nationalIdImg = "" ;
    passportImg="";
    drivingLicenseImg="";
    _fetchData();
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
            nationalIdImg = mediaList?.nationalIdImage?.kycDocsImageUrl ;
            passportImg = mediaList?.passportImage?.kycDocsImageUrl;
            drivingLicenseImg = mediaList?.drivingLicenseImage?.kycDocsImageUrl;
          });
        });
        Navigator.pushNamed(context, "/AddMoneyScreen");
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
            buildBirthdateSection(),
            Text("Uploaded Documents", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            buildDocumentSection("National Id", nationalIdImg as String,screenHeight, screenWidth),
            // buildDocumentSection("Passport", passportImg,screenHeight),
            // buildDocumentSection("Driving License", drivingLicenseImg,screenHeight),
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
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

  Future<ProfileResponse?> _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        firstName = profileDetails?.firstName;
        lastName = profileDetails?.lastName;
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
}
