import 'package:Payrio/model/request/saveAddressRequest.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/profileResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/toastMessage.dart';

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
  late bool isDarkMode;

  static const maxDuration = Duration(seconds: 2);
  final ConnectivityService _connectivityService = ConnectivityService();

  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputValid = false;
    isLoading = true;
    _fetchData();
  }

  void _isValidInput() {
    //print(input);
    if (_streetController.text.isNotEmpty &&
        _streetNumberController.text.isNotEmpty &&
        _stateController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _postalCodeController.text.isNotEmpty &&
        (streetName != _streetController.text ||
            streetNumber != _streetNumberController.text ||
            city != _cityController.text ||
            state != _stateController.text ||
            postCode != _postalCodeController.text)) {
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

  Future<Widget> getChangeAddressResponse(
      BuildContext context, ApiResponse apiResponse) async {
    ProfileResponse mediaList = apiResponse.data;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("response: ${apiResponse}");

        ToastComponent.showToast(
            context: context, message: "${apiResponse.message}");
        Navigator.pushNamed(context, '/ProfileScreen');
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse?.message}") == nonCapitalizeString("${Languages.of(context)?.labelInvalidAccessToken}"))
          SessionExpiredDialog.showDialogBox(context: context);
        else
          ToastComponent.showToast(
              context: context, message: "${apiResponse.message}");
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
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
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
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight * 0.88 -
                      MediaQuery.of(context).viewInsets.bottom,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField(
                            Languages.of(context)!.labelStreetName, streetName,
                            (value) {
                          setState(() {
                            streetName = value;
                          });
                        }, _streetController, 20),
                        buildTextField(
                            Languages.of(context)!.labelStreetNo, streetNumber,
                            (value) {
                          setState(() {
                            streetNumber = value;
                          });
                        }, _streetNumberController, 20),
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
                                  Languages.of(context)!.labelState, state,
                                  (value) {
                                setState(() {
                                  state = value;
                                });
                              }, _stateController, 15),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: buildTextField(
                                  Languages.of(context)!.labelCity, city,
                                  (value) {
                                setState(() {
                                  city = value;
                                });
                              }, _cityController, 15),
                            ),
                            Expanded(
                              flex: 1,
                              child: buildTextField(
                                  Languages.of(context)!.labelPostalCode,
                                  postCode, (value) {
                                setState(() {
                                  postCode = value;
                                });
                              }, _postalCodeController, 15),
                            ),
                          ],
                        ),
                        Spacer(),
                        _buildFooter(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            isLoading
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
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String text, Function(String) onChanged,
      TextEditingController nameController, int limit) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: isDarkMode ? Colors.grey : Colors.black, width: 0.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 5),
            child: Text(
              "$label",
              style: TextStyle(fontSize: 13),
            ),
          ),
          Row(
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
                  maxLength: limit,
                  onSubmitted: (value) {},
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: label,
                    counterText: "",
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ],
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
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                hideKeyBoard();
                _isValidInput();
                print(_streetController.text);
                if (inputValid) {
                  saveAddress();
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
                  backgroundColor: inputValid ? AppColor.PRIMARY : Colors.white,
                  elevation: 3,
                  shape:
                      BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveAddress() async {
    {
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
      } else {
        print(_cityController.text);
        SaveAddressDetails params = SaveAddressDetails(
            line1: "${_streetController.text}",
            line2: "${_streetNumberController.text}",
            city: capitalizeFirstLetter("${_cityController.text}"),
            state: capitalizeFirstLetter("${_stateController.text}"),
            postalCode: "${_postalCodeController.text}");

        SaveAddressRequest request = SaveAddressRequest(addressParams: params);

        await Provider.of<MainViewModel>(context, listen: false)
            .saveAddressData("api/v1/app/customers/update_address", request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;

        hideKeyBoard();
        getChangeAddressResponse(context, apiResponse);
      }
    }
  }

  Future<void> _fetchData() async {
    Helper.getProfileDetails().then((profile) {
      setState(() {
        streetName = "${profile?.address?.line1}";
        streetNumber = "${profile?.address?.line2}";
        city = "${profile?.address?.city}";
        state = "${profile?.address?.state}";
        postCode = "${profile?.address?.postal_code}";
        isLoading = false;
        streetName != "null" ? _streetController.text = streetName : "";
        streetNumber != "null" ? _streetNumberController.text = streetNumber : "";
        city != "null" ? _cityController.text = city:"";
        state != "null" ? _stateController.text = state:"";
        postCode != "null" ? _postalCodeController.text = postCode:"";
      });
    });
  }
}
