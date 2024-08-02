import 'dart:io';

import 'package:Payrio/model/apis/api_response.dart';
import 'package:Payrio/model/response/createSupportTicketResponse.dart';
import 'package:Payrio/utils/Util.dart';
import 'package:Payrio/view_model/main_view_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../languageSection/Languages.dart';
import '../../../../../theme/AppColor.dart';
import '../../../../component/connectivity_service.dart';
import '../../../../component/toastMessage.dart';

class CreateSupportTicketScreen extends StatefulWidget {
  @override
  _CreateSupportTicketScreenState createState() =>
      _CreateSupportTicketScreenState();
}

class _CreateSupportTicketScreenState extends State<CreateSupportTicketScreen> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  String? imageUrl = "";
  File? galleryFile;
  final picker = ImagePicker();
  bool inputValid = false;
  bool isDarkMode = false;
  String serviceTypeValue = "";
  String bankTypeValue = "";
  String issueTypeValue = "";
  String methodTypeValue = "";
  var serviceTypeList = ["Select", "Service1", "Service2", "Service3"];
  var bankTypeList = ["Select", "Bank1", "Bank2", "Bank3"];
  var issueTypeList = ["Select", "Issue1", "Issue2", "Issue3"];
  var methodTypeList = ["Select", "Method1", "Method2", "Method3"];
  late double screenWidth;

  ///Time
  TimeOfDay timeOfDay = TimeOfDay.now();
  String selectedTime = "Payment Time";
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmPasswordVisible = true;
    inputValid = false;
    isDarkMode = false;
    serviceTypeValue = serviceTypeList.first;
    bankTypeValue = bankTypeList.first;
    methodTypeValue = methodTypeList.first;
    issueTypeValue = issueTypeList.first;
  }

  void _isValidInput() {
    //print(input);
    if (_amountController.text.isNotEmpty &&
        _paymentTimeController.text.isNotEmpty &&
        _customerNumberController.text.isNotEmpty &&
        _transactionIdController.text.isNotEmpty &&
        _serviceTypeController.text.isNotEmpty &&
        _bankTypeController.text.isNotEmpty &&
        _commentController.text.isNotEmpty &&
        _issueTypeController.text.isNotEmpty &&
        _methodTypeController.text.isNotEmpty) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });
    }
  }

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _paymentTimeController = TextEditingController(text: "00:00");
  final TextEditingController _customerNumberController =
      TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _bankTypeController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _issueTypeController = TextEditingController();
  final TextEditingController _methodTypeController = TextEditingController();

  Future<Widget> getSetUpAccountWidget(
      BuildContext context, ApiResponse apiResponse) async {
    CreateSupportTicketResponse? createSupportTicketResponse =
        apiResponse.data as CreateSupportTicketResponse?;
    String? message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${createSupportTicketResponse?.trxId}");

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
    screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight * 0.95),
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16, top: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            _buildLabelText(
                                context, "Create Support Ticket", 20, true),
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            _buildPhoneInput(
                                context,
                                "Amount",
                                _amountController,
                                Icon(
                                  Icons.money,
                                  size: 20,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                )),
                            SizedBox(height: 10),
                            _buildPaymentTimeInput(
                                context,
                                "Payment Time",
                                _paymentTimeController,
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                )),
                            SizedBox(height: 10),
                            _buildPhoneInput(
                                context,
                                "Customer Number",
                                _customerNumberController,
                                Icon(
                                  Icons.phone,
                                  size: 18,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                )),
                            SizedBox(height: 10),
                            _buildPasswordInput(
                                context,
                                "Transaction Id",
                                _transactionIdController,
                                Icon(
                                  Icons.numbers,
                                  size: 18,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                isDarkMode),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDropDownWidget(
                                    context,
                                    "",
                                    _serviceTypeController,
                                    Icon(Icons.merge),
                                    serviceTypeList,
                                    serviceTypeValue,
                                  ""
                                ),
                                _buildDropDownWidget(
                                    context,
                                    "",
                                    _bankTypeController,
                                    Icon(Icons.merge),
                                    bankTypeList,
                                    bankTypeValue,
                                ""),
                              ],
                            ),
                            SizedBox(height: 10),
                            _buildPasswordInput(
                                context,
                                "Comment",
                                _commentController,
                                Icon(
                                  Icons.merge_type,
                                  size: 18,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                isDarkMode),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDropDownWidget(
                                    context,
                                    "",
                                    _issueTypeController,
                                    Icon(Icons.merge),
                                    issueTypeList,
                                    issueTypeValue,""),
                                _buildDropDownWidget(
                                    context,
                                    "",
                                    _methodTypeController,
                                    Icon(Icons.merge),
                                    methodTypeList,
                                    methodTypeValue,""),
                              ],
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: Card(
                                child: Container(
                                  width: screenWidth*0.6,
                                  decoration: BoxDecoration(
                                    color: AppColor.PRIMARY,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      imageUrl == ""
                                          ? Container(
                                              height: 130,
                                              width: 130,
                                              child: Image.asset(
                                                "assets/india_flag_icon.png",
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                right: BorderSide(
                                                    color: AppColor.PRIMARY),
                                                left: BorderSide(
                                                    color: AppColor.PRIMARY),
                                                top: BorderSide(
                                                    color: AppColor.PRIMARY),
                                                bottom: BorderSide(
                                                    color: AppColor.PRIMARY),
                                              )),
                                              child: Image.file(
                                                galleryFile!,
                                                height: 130,
                                                width: 130,
                                                fit: BoxFit.cover,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Container(
                                                    height: 130,
                                                    width: 130,
                                                    child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor:
                                                          AppColor.WHITE,
                                                      backgroundImage:
                                                          AssetImage(
                                                        "assets/profile_user.png",
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                      GestureDetector(
                                        onTap: (){
                                          _showPicker(context: context);
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: AppColor.WHITE,
                                          size: 54,
                                        ),
                                      ),
                                      SizedBox(width: 2,)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        _buildFooter(context, apiResponse),
                      ],
                    )),
              ),
            ),
            isLoading
                ? Stack(
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
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource image,
  ) async {
    final pickedFile = await picker.pickImage(source: image);
    XFile? xfilePick = pickedFile;

    if (xfilePick != null) {
      galleryFile = File(pickedFile!.path);
      File? compressedFile =
          await _resizeAndCompressImage(galleryFile as File, 800);
      if (compressedFile != null) {
        setState(() {
          imageUrl = compressedFile.toString();
          print("imageUrl:: ${imageUrl}");
          //_uploadProfilePic(compressedFile);
        });
      } else {
        print('Compression failed.');
      }

      //print(compressedFile);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
          const SnackBar(content: Text('Nothing is selected')));
    }
  }

  Future<File?> _resizeAndCompressImage(File file, int targetWidth) async {
    try {
      final directory = await getTemporaryDirectory();
      final targetPath = path.join(directory.path,
          '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        minWidth: targetWidth,
        quality: 85, // Adjust quality to balance size and quality
        format: CompressFormat.jpeg,
        keepExif: false, // Remove metadata
      );

      if (result == null) {
        print('Resizing and compression failed.');
        return null;
      }

      print('Original size: ${file.lengthSync()} bytes');
      print('Resized and compressed size: ${result.lengthSync()} bytes');

      return result;
    } catch (e) {
      print('Error resizing and compressing image: $e');
      return null;
    }
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
                keyboardType: TextInputType.number,
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

  Widget _buildDropDownWidget(
      BuildContext context,
      String text,
      TextEditingController nameController,
      Icon icon,
      List<String> typeList,
      String selectedValue,
      String labelText) {
    return Card(
      child: Container(
        height: 80,
        width: screenWidth * 0.42,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("data"),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: isDarkMode ? Colors.grey : Colors.white,
                      alignment: Alignment.center,
                      value: selectedValue,
                      items: typeList.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          alignment: Alignment.centerLeft,
                          child: Text(item,
                              style: TextStyle(
                                fontSize: 14,
                              )),
                        );
                      }).toList(),
                      onChanged: (String? newValue) async {
                        if (mounted) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        }
                        print(selectedValue);
                      },
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                      hint: Text(
                        "en",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _paymentTimeController.text = "${time.hour}:${time.minute} ${time.period.name}";
        selectedTime = "${time.hour}:${time.minute} ${time.period.name}";
      });
    }
  }

  Widget _buildPaymentTimeInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon) {
    return GestureDetector(
      child: Card(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Icon(Icons.access_time,
                  color: isDarkMode? AppColor.WHITE: AppColor.TEXT_COLOR,),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    selectedTime,
                    style: TextStyle(
                      color: selectedTime == "Payment Time" ? Colors.grey : AppColor.TEXT_COLOR,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () async {
                    hideKeyBoard();
                    displayTimePicker(context);
                  },
                  child: Icon(Icons.timer_outlined)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInput(
    BuildContext context,
    String text,
    TextEditingController nameController,
    Icon icon,
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
                style: TextStyle(
                  fontSize: 16.0,
                ),
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

  Widget _buildFooter(BuildContext context, ApiResponse apiResponse) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              _isValidInput();
              const maxDuration = Duration(seconds: 2);
              print(_amountController.text);
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
                        content: Text('${Languages.of(context)?.labelNoInternetConnection}'),
                        duration: maxDuration,
                      ),
                    );
                  });
                } else {
                  await Provider.of<MainViewModel>(context, listen: false)
                      .postMultiFormResponseToCreateSupport(
                          url: "/api/v1/app/support_tickets",
                          amount: _amountController.text,
                          bankType: _bankTypeController.text,
                          comment: _commentController.text,
                          customerNumber: _customerNumberController.text,
                          issueType: _issueTypeController.text,
                          paymentTime: _paymentTimeController.text,
                          serviceType: _serviceTypeController.text,
                          supportTicketDocument: File(imageUrl!),
                          trxId: _transactionIdController.text);
                  //Navigator.pushNamed(context, '/BottomNav');

                  ApiResponse apiResponse =
                      Provider.of<MainViewModel>(context, listen: false)
                          .response;
                  getSetUpAccountWidget(context, apiResponse);
                }
              } else {
                if (_amountController.text.isEmpty &&
                    _paymentTimeController.text.isEmpty &&
                    _customerNumberController.text.isEmpty &&
                    _transactionIdController.text.isEmpty &&
                    _serviceTypeController.text.isEmpty &&
                    _bankTypeController.text.isEmpty &&
                    _commentController.text.isEmpty &&
                    _issueTypeController.text.isEmpty &&
                    _methodTypeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter all the details'),
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
                backgroundColor: inputValid
                    ? AppColor.PRIMARY
                    : AppColor.SHORTCUT_CARD_LIGHT_COLOR,
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
