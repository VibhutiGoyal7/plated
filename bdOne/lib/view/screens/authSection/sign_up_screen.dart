import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../model/response/setUpAccountResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/toastMessage.dart';

class SignUpScreen extends StatefulWidget {
  final String? userId; // Define the 'data' parameter here

  SignUpScreen({Key? key, this.userId}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;
  String token = "";
  String? selectedGender = "Male";
  final ConnectivityService _connectivityService = ConnectivityService();

  bool inputValid = false;
  bool isDarkMode = false;
  late double screenWidth;
  late MainViewModel _viewModel;
  late ApiResponse apiResponse;
  static const maxDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmPasswordVisible = true;
    inputValid = false;
    isDarkMode = false;
    //ViewModel
    _viewModel = Provider.of<MainViewModel>(context, listen: false);
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
        validatePassword(_passwordController.text) &&
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
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<Widget> getSetUpAccountWidget(BuildContext context) async {
    SetUpAccountResponse? setUpAccountResponse =
        apiResponse.data as SetUpAccountResponse?;
    String? message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(
            child: CircularProgressIndicator(
          color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY_ACCENT,
        ));
      case Status.COMPLETED:
        print("GetSetUpAccountWidget : ${setUpAccountResponse?.firstName}");
        bool isSaved = await Helper.saveUserToken(token);

        // Check if the token was saved successfully
        if (isSaved) {
          print('Token saved successfully.');
        } else {
          print('Failed to save token.');
        }
        Helper.getUserToken();
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

        Navigator.pushReplacementNamed(context, '/BottomNav', arguments: 0);
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
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            hideKeyBoard();
          },
          child: Stack(
            children: [
              CustomScrollView(slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: _buildLabelText(
                                context,
                                Languages.of(context)!.labelSignup,
                                24,
                                true,
                                false),
                          ),
                        ),
                        SizedBox(height: 15),
                        _buildTextInput(
                            context,
                            Languages.of(context)!.labelName,
                            "e.g John",
                            _nameController,
                            Icon(
                              Icons.person,
                              size: 20,
                              color: isDarkMode ? Colors.white : Colors.black,
                            )),
                        SizedBox(height: 8),
                        _buildTextInput(
                            context,
                            Languages.of(context)!.labelEmailAddress,
                            "e.g john@example.com",
                            _lastNameController,
                            Icon(
                              Icons.person,
                              size: 20,
                              color: isDarkMode ? Colors.white : Colors.black,
                            )),
                        SizedBox(height: 8),
                        _buildPhoneInput(
                            context,
                            Languages.of(context)!.labelVerifyYourMobileNumber,
                            "+115315......",
                            _emailController,
                            Icon(
                              Icons.mail,
                              size: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            )),
                        SizedBox(height: 8),
                        _buildTransactionMethodWidget(
                            context,
                            "",
                            _genderController,
                            Icon(Icons.merge),
                            ['Male', 'Female', 'Others'],
                            selectedGender,
                            "${Languages.of(context)!.labelGender}"),
                        /*   SizedBox(height: 10),
                        _buildDOBInput(
                            context,
                            Languages.of(context)!.labelGender,
                            _dateController,
                            Icon(
                              Icons.calendar_month,
                              size: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            )),*/
                        SizedBox(height: 8),
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
                        SizedBox(height: 8),
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
                        /*    Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: _buildLabelText(
                              context,
                              "${Languages.of(context)?.labelPasswordRequirement}",
                              9,
                              false),
                        ),*/
                        SizedBox(height: 40),
                        _buildFooter(context),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      margin: const EdgeInsets.only(bottom: 20.0, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${Languages.of(context)?.labelAlreadyHaveAnAcc} ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/SignInScreen');
                            },
                            child: Text(
                              "${Languages.of(context)?.labelLogin}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.PRIMARY_ACCENT,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
              isLoading
                  ? Stack(
                      children: [
                        // Block interaction
                        ModalBarrier(
                            dismissible: false, color: Colors.transparent),
                        // Loader indicator
                        Center(
                          child: CircularProgressIndicator(
                            color: isDarkMode
                                ? AppColor.WHITE
                                : AppColor.PRIMARY_ACCENT,
                          ),
                        ),
                      ],
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  _buildLabelText(BuildContext context, String text, int size, bool isBold,
      bool isSubHeading) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size.toDouble(),
          fontWeight: isBold ? FontWeight.w400 : FontWeight.normal,
          color: isSubHeading
              ? Theme.of(context).highlightColor
              : Theme.of(context).focusColor),
    );
  }

  Widget _buildTextInput(BuildContext context, String text, String hint,
      TextEditingController nameController, Icon icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
          child: _buildLabelText(context, text, 13, true, true),
        ),
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: isDarkMode ? AppColor.BLACK : AppColor.WHITE,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 2,
              ),
            ],
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
                  controller: nameController,
                  onChanged: (value) {
                    _isValidInput();
                  },
                  textAlignVertical: TextAlignVertical.center,
                  onSubmitted: (value) {},
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? Theme.of(context).focusColor
                            : Theme.of(context).highlightColor),
                    hintText: hint,
                    //icon: icon,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput(BuildContext context, String text, String hint,
      TextEditingController nameController, Icon icon) {
    //nameController.text = widget.data as String;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
          child: _buildLabelText(context, text, 13, true, true),
        ),
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: isDarkMode ? AppColor.BLACK : AppColor.WHITE,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  //obscureText: false,
                  controller: nameController,
                  onChanged: (value) {
                    _isValidInput();
                  },
                  maxLength: 12,
                  //scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  onSubmitted: (value) {},
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    //alignLabelWithHint: true,
                    counterText: "",
                    //icon: icon,
                    /*suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${Languages.of(context)?.labelSaveId}",
                            style: TextStyle(fontSize: 10),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            semanticLabel: "${Languages.of(context)?.labelSaveId}",
                            side: BorderSide(
                                color: isDarkMode ? Colors.white : Colors.black),
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                        ],
                      )*/
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDOBInput(BuildContext context, String text,
      TextEditingController dateController, Icon icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
          child: _buildLabelText(context, text, 14, true, true),
        ),
        Container(
          height: 55,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: isDarkMode ? AppColor.BLACK : AppColor.WHITE,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 2,
              ),
            ],
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
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                          icon: icon
                          //icon of text field
                          ),
                      readOnly: true,
                      // when true user cannot edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now()
                                .subtract(Duration(days: 365 * 18)),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime.now()
                                .subtract(Duration(days: 365 * 18)),
                            helpText:
                                "${Languages.of(context)?.labelSelectDob}",
                            confirmText:
                                "${Languages.of(context)?.labelConfirm}",
                            errorFormatText:
                                '${Languages.of(context)?.labelEnterValidDate}',
                            errorInvalidText:
                                '${Languages.of(context)?.labelEnterDateInValidRange}',
                            builder: (context, child) {
                              return Theme(
                                data: isDarkMode
                                    ? ThemeData.dark()
                                    : ThemeData.light(),
                                // This will change to light theme.
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
      ],
    );
  }

  Widget _buildTransactionMethodWidget(
      BuildContext context,
      String text,
      TextEditingController nameController,
      Icon icon,
      List<String> genderList,
      String? selectedGender,
      String labelText) {
    final GlobalKey _buttonKey = GlobalKey();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            labelText,
            style: TextStyle(fontSize: 14),
          ),
        ),
        InkWell(
          onTap: () {
            final RenderBox button =
                _buttonKey.currentContext?.findRenderObject() as RenderBox;
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;

            // Adjust position for bottom alignment
            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                button.localToGlobal(Offset(0, button.size.height),
                    ancestor: overlay),
                // Start from bottom of the card
                button.localToGlobal(button.size.bottomRight(Offset.zero),
                    ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            );
            showMenu(
              context: context,
              position: position,
              items: genderList.map((item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(
                    capitalizeFirstLetter("${item}"),
                    style: TextStyle(color: AppColor.WHITE),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              // Adjust the popup width to match the button width
              constraints: BoxConstraints(
                minWidth: button.size.width,
                maxWidth: button.size.width,
              ),
            ).then((value) {
              if (value != null) {
                _changeGenderValue(value);
              }
            });
          },
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: isDarkMode ? AppColor.BLACK : AppColor.WHITE,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Row(
                key: _buttonKey,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  selectedGender?.isEmpty == true
                      ? Container(
                          child: Text("Select $labelText"),
                        )
                      : Text(
                          "${selectedGender}".isEmpty
                              ? '$labelText'
                              : capitalizeFirstLetter("${selectedGender}"),
                          style: TextStyle(fontSize: 14),
                        ),
                  //SizedBox(width: 5),
                  Icon(Icons.keyboard_arrow_down_sharp),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _changeGenderValue(String? newValue) {
    setState(() {
      selectedGender = newValue;
      _genderController.text = newValue.toString();
    });
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
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
          child: _buildLabelText(context, text, 13, true, true),
        ),
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: isDarkMode ? AppColor.BLACK : AppColor.WHITE,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
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
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    //icon: icon,
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisibles
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 24,
                        color: isDarkMode ? Colors.white60 : Colors.black45,
                      ),
                      onPressed: () {
                        setState(
                          () {
                            if (text ==
                                "${Languages.of(context)?.labelPassword}") {
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
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: screenWidth,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: inputValid ? AppColor.PRIMARY_ACCENT : Colors.grey.shade300,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 2),
            blurRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      margin: const EdgeInsets.symmetric(
        horizontal: 14.0,
      ),
      child: MaterialButton(
        onPressed: () async {
          hideKeyBoard();
          Navigator.pushNamed(context, '/SignInScreen');
          _isValidInput();
          const maxDuration = Duration(seconds: 2);
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
                    content: Text(
                        '${Languages.of(context)?.labelNoInternetConnection}'),
                    duration: maxDuration,
                  ),
                );
              });
            } else {
              //await Provider.of<MainViewModel>(context, listen: false).signInWithPass("api/v1/app/customers/sign_in", request);
              //Navigator.pushNamed(context, '/BottomNav');

              ApiResponse apiResponse =
                  Provider.of<MainViewModel>(context, listen: false).response;
              //getSignInResponse(context, apiResponse);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('${Languages.of(context)?.labelPleaseEnterAllDetails}'),
              duration: maxDuration,
            ));
          }
        },
        child: Text(
          Languages.of(context)!.labelConfirm,
          style: TextStyle(
              color: inputValid ? Colors.white : AppColor.PRIMARY,
              fontSize: 16),
        ),
      ),
    );
  }

  void Validate(String email) {
    bool isValid = EmailValidator.validate(email);
    print(isValid);
  }

  bool validatePassword(String password) {
    // Regular expression pattern for password validation
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$';

    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }
}
