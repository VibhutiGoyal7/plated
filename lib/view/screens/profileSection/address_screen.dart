import 'package:flutter/material.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String streetName = "";
  String streetNumber = "";
  String state = "";
  String city = "";
  String postCode = "";
  bool inputValid = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    inputValid = false;
    isLoading = true;
    _fetchData();
  }

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  void _isValidInput() {
    //print(input);
    if (_streetController.text.isNotEmpty &&
        _streetNumberController.text.isNotEmpty &&
        _stateController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _postalCodeController.text.isNotEmpty) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });
    }
  }

  String address = "";


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 65,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          Languages.of(context)!.labelAddressDetails,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField(Languages.of(context)!.labelStreetName, streetName,
                      (value) {
                    setState(() {
                      streetName = value;
                    });
                  }, _streetController),
                  buildTextField(Languages.of(context)!.labelStreetNo, streetNumber,
                      (value) {
                    setState(() {
                      streetNumber = value;
                    });
                  }, _streetNumberController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildReadOnlyField(
                            Languages.of(context)!.labelCountry,
                            Languages.of(context)!.labelIndia,
                            isDarkMode),
                      ),
                      Expanded(
                        flex: 1,
                        child: buildTextField(
                            Languages.of(context)!.labelState, state, (value) {
                          setState(() {
                            state = value;
                          });
                        }, _stateController),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildTextField(
                            Languages.of(context)!.labelCity, city, (value) {
                          setState(() {
                            city = value;
                          });}
                        , _cityController),
                      ),
                      Expanded(
                        flex: 1,
                        child: buildTextField(
                            Languages.of(context)!.labelPostalCode, postCode,
                            (value) {
                          setState(() {
                            postCode = value;
                          });
                        }, _postalCodeController),
                      ),
                    ],
                  ),
                  Spacer(),
                  _buildFooter(context),
                ],
              ),
            ),
            isLoading
                ? Stack(
              children: [
                // Block interaction
                ModalBarrier(
                    dismissible: false,
                    color : Colors.black.withOpacity(0.3)),
                // Loader indicator
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String text, Function(String) onChanged,
      TextEditingController nameController) {
    return Card(
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                style: TextStyle(
                  fontSize: 14.0,
                ),
                controller: nameController,
                onChanged: (value) {
                  _isValidInput();
                },
                onSubmitted: (value) {},
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: label,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReadOnlyField(String label, String value, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(right: 20, left: 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                _isValidInput();
                print(_streetController.text);
                if (inputValid) {
                  Navigator.pushNamed(context, '/BottomNav');
                  //getMediaWidget(context, apiResponse);
                }
              },
              child: Text(
                Languages.of(context)!.labelConfirm,
                style: TextStyle(
                    color: inputValid ? Colors.white : AppColor.PRIMARY),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor:
                      inputValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape:
                      BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
            ),
          ),
        ],
      ),
    );
  }
  Future<ProfileResponse?> _fetchData() async {
    //await Future.delayed(Duration(milliseconds: 2));
    ProfileResponse? profileDetails = await Helper.getProfileDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        address = (profileDetails?.address == null? "" : profileDetails?.address)! ;
        isLoading = false;
      });
    });
    return profileDetails;
  }
}
