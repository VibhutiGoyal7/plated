import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/model/request/setUpAccountRequest.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/response/setUpAccountResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../component/connectivity_service.dart';
import '../../component/toastMessage.dart';

class SetUpAccountScreen extends StatefulWidget {
  final String? userId; // Define the 'data' parameter here

  SetUpAccountScreen({Key? key, this.userId}) : super(key: key);

  @override
  _SetUpAccountScreenState createState() => _SetUpAccountScreenState();
}

class _SetUpAccountScreenState extends State<SetUpAccountScreen> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  bool inputValid = false;
  bool isDarkMode = false;
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmPasswordVisible = true;
    inputValid = false;
    isDarkMode = false;
  }

  void _isValidInput() {
    //print(input);
    if (_emailController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text.length >= 8 &&
        _passwordController.text == _confirmPasswordController.text &&
        EmailValidator.validate(_emailController.text)) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });

    }
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<Widget> getSetUpAccountWidget(
      BuildContext context, ApiResponse apiResponse) async {
    SetUpAccountResponse? setUpAccountResponse =
        apiResponse.data as SetUpAccountResponse?;
    String? message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${setUpAccountResponse?.firstName}");
        await Helper.saveProfileDetails(setUpAccountResponse);
        if (await Helper.saveProfileDetails(setUpAccountResponse))
          print("data saved");
        else
          print("not saved");

        await Helper.savePassword(_passwordController.text);
        await Helper.saveCountry(setUpAccountResponse?.countryName);
        await Helper.saveKycStatus(setUpAccountResponse?.kycStatus);
        String? password = await Helper.getPassword();
        print("password: ${password}");
        await Helper.getUserDetails();

        Navigator.pushReplacementNamed(context, '/BottomNav');
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        ToastComponent.showToast(context: context, message: message);
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      body: SafeArea(
        child:
        GestureDetector(
          onTap: (){
            hideKeyBoard();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: screenHeight * 0.95),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelText(
                                  context,
                                  Languages.of(context)!.labelAlmostFinish,
                                  15,
                                  false),
                              SizedBox(height: 1),
                              _buildLabelText(context,
                                  Languages.of(context)!.labelSetProfile, 20, true),
                              SizedBox(height: 8),
                              _buildLabelText(
                                  context,
                                  Languages.of(context)!.labelTellAbtYourself,
                                  18,
                                  false),
                              SizedBox(height: 20),
                              /*Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildLabelText(
                                      context,
                                      Languages.of(context)!.labelPromoCode,
                                      14,
                                      false),
                                  _buildLabelText(context,
                                      Languages.of(context)!.labelRedeem, 14, false),
                                ],
                              ),*/
                              SizedBox(height: 10),
                              _buildPhoneInput(
                                  context,
                                  Languages.of(context)!.labelName,
                                  _nameController,
                                  Icon(
                                    Icons.person,
                                    size: 20,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  )),
                              SizedBox(height: 10),
                              _buildPhoneInput(
                                  context,
                                  Languages.of(context)!.labelLastname,
                                  _lastNameController,
                                  Icon(
                                    Icons.person,
                                    size: 20,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  )),
                              SizedBox(height: 10),
                              _buildPhoneInput(
                                  context,
                                  Languages.of(context)!.labelEmail,
                                  _emailController,
                                  Icon(
                                    Icons.mail,
                                    size: 18,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  )),
                              SizedBox(height: 10),
                              _buildDOBInput(
                                  context,
                                  Languages.of(context)!.labelDOB,
                                  _dateController,
                                  Icon(
                                    Icons.calendar_month,
                                    size: 18,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  )
                              ),
                              SizedBox(height: 10),
                              _buildPasswordInput(
                                  context,
                                  Languages.of(context)!.labelPassword,
                                  _passwordController,
                                  Icon(
                                    Icons.password,
                                    size: 18,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  passwordVisible,
                                  isDarkMode),
                              SizedBox(height: 10),
                              _buildPasswordInput(
                                  context,
                                  Languages.of(context)!.labelConfirmPass,
                                  _confirmPasswordController,
                                  Icon(
                                    Icons.password,
                                    size: 18,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  confirmPasswordVisible,
                                  isDarkMode),
                            ],
                          ),
                          _buildFooter(context, apiResponse),
                        ],
                      )),
                ),
              ),
              isLoading ? Stack(
                children: [
                  // Block interaction
                  ModalBarrier(
                      dismissible: false,
                      color: Colors.transparent),
                  // Loader indicator
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ): SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text, int size, bool isBold) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildPhoneInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon) {
    return Card(
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                style: TextStyle(
                  fontSize: 16.0,
                ),
                obscureText: false,
                obscuringCharacter: "*",
                controller: nameController,
                onChanged: (value) {
                  _isValidInput();
                },
                onSubmitted: (value) {},
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: text,
                  hintStyle: TextStyle(color: Colors.grey),
                  icon: icon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget  _buildDOBInput(BuildContext context, String text,
      TextEditingController dateController, Icon icon) {
    return Card(
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
                child: TextField(
                    controller: dateController,
                    //editing controller of this TextField
                    textInputAction: TextInputAction.done,

                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: Languages.of(context)!.labelBirthdate,
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: icon
                        //icon of text field
                        ),
                    readOnly: true,
                    // when true user cannot edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate:DateTime.now().subtract(Duration(days: 365*18)),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime.now().subtract(Duration(days: 365*18)),
                          helpText: "Select Date Of Birth",
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
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          _dateController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    })),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon) {
    return Card(
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                style: TextStyle(
                  fontSize: 16.0,
                ),
                obscureText: false,
                obscuringCharacter: "*",
                controller: nameController,
                onChanged: (value) {
                  _isValidInput();
                },
                onSubmitted: (value) {},
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: text,
                  hintStyle: TextStyle(color: Colors.grey),
                  icon: icon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordInput(
    BuildContext context,
    String text,
    TextEditingController nameController,
    Icon icon,
    bool passwordVisibles,
    bool isDarkMode,
  ) {
    return Card(
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(fontSize: 16.0,),
                obscureText: passwordVisibles,
                obscuringCharacter: "*",
                controller: nameController,
                onChanged: (value) {
                  _isValidInput();
                },
                onSubmitted: (value) {},
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: text,
                  hintStyle: TextStyle(color: Colors.grey),
                  icon: icon,
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisibles
                          ? Icons.visibility
                          : Icons.visibility_off,
                      size: 20,
                      color: isDarkMode ? Colors.white60 : Colors.black45,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          if (text == "Password") {
                            passwordVisible = !passwordVisible;
                          } else {
                            confirmPasswordVisible = !confirmPasswordVisible;
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ApiResponse apiResponse) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              hideKeyBoard();
              _isValidInput();
              const maxDuration = Duration(seconds: 2);
              print(_nameController.text);
              if (inputValid) {
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
                        Text('No internet connection'),
                        duration: maxDuration,
                      ),
                    );
                  });
                }else {
                  SetUpAccountRequest request = SetUpAccountRequest(
                      customer: CustomerDetail(
                        email: _emailController.text,
                        password: _passwordController.text,
                        firstName: _nameController.text,
                        lastName: _lastNameController.text,
                        dob: _dateController.text,
                      ));
                  await Provider.of<MainViewModel>(context, listen: false)
                      .fetchSetUpScreenData(
                      "/api/v1/app/customers/update_customer", request);
                  //Navigator.pushNamed(context, '/BottomNav');

                  ApiResponse apiResponse =
                      Provider
                          .of<MainViewModel>(context, listen: false)
                          .response;
                  getSetUpAccountWidget(context, apiResponse);
                }
              }else {
                if(_emailController.text.isEmpty &&
                    _nameController.text.isEmpty &&
                    _lastNameController.text.isEmpty &&
                    _passwordController.text.isEmpty &&
                    _dateController.text.isEmpty &&
                    _confirmPasswordController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter all the details'),
                      duration: maxDuration,
                    ),
                  );
                }else if(!EmailValidator.validate(_emailController.text)){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enter valid email address.'),
                      duration: maxDuration,
                    ),
                  );

                }else if(_passwordController.text.length < 8){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password should have 8 or more characters.'),
                      duration: maxDuration,
                    ),
                  );

                }else if(_passwordController.text != _confirmPasswordController.text){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Password doesn't match"),
                      duration: maxDuration,
                    ),
                  );

                }
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
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
          ),
        ),
     /*   Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Do you need any help?",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ),*/
      ],
    );
  }

  void Validate(String email) {
    bool isValid = EmailValidator.validate(email);
    print(isValid);
  }
}
