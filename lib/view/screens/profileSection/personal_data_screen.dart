import 'package:flutter/material.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/response/profileResponse.dart';
import '../../../utils/Helper.dart';

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
    documentNumber = "";
    _fetchData();
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
            buildDocumentDropdown(),
            buildDocumentNumberSection(),
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
        userName = profileDetails?.username;
        dob = profileDetails?.dob;
      });
    });
    return profileDetails;
  }
}
