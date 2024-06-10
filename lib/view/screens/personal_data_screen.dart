import 'package:flutter/material.dart';

import '../../model/profileResponse.dart';
import '../../utils/Helper.dart';

class PersonalDataScreen extends StatefulWidget {
  @override
  _PersonalDataScreenState createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  var firstName ;
  var lastName ;
  var documentNumber;
  var dob ;

  bool mExpanded = false;
  String mSelectedText = "";
  final List<String> mCities = ["Aadhar", "PanCard"];
  final TextEditingController documentNumberController = TextEditingController();


  @override
  void initState() {
    super.initState();
    firstName="";
    lastName="";
    dob="" ;
    documentNumber ="" ;
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
          'Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProfileSection("First Name", firstName),
            buildProfileSection("Last Name", lastName),
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
            'Birthdate',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.calendar_today),
        ],
      ),
    );
  }

  Widget buildDocumentDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            readOnly: true,
            controller: TextEditingController(text: mSelectedText),
            decoration: InputDecoration(
              labelText: 'Choose Document',
              suffixIcon: IconButton(
                icon: Icon(mExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
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
            'Document Number',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextField(
            controller: documentNumberController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
        lastName= profileDetails?.lastName;
        dob=profileDetails?.dob;
      });

    });
    return profileDetails;
  }
}
