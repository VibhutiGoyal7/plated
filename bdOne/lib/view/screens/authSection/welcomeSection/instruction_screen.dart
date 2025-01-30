import 'package:BDOne/languageSection/Languages.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:BDOne/utils/Helper.dart';
import 'package:BDOne/view/component/instruction_step.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/apis/api_response.dart';
import '../../../../model/response/countryListResponse.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/custom_circular_progress.dart';

class InstructionScreen extends StatefulWidget {
  @override
  _InstructionScreenState createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  PageController _pageController = PageController();
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    //_fetchData();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {},
          child: Container(
            height: screenHeight,
            child: Stack(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed("/CreateAccountScreen");
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          color: AppColor.WHITE,
                        ),
                      ),
                      alignment: Alignment.topRight,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "${Languages.of(context)?.labelCreateBDOneAccount}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        InstructionStep(
                            icon: Icons.document_scanner_rounded,
                            title: "${Languages.of(context)?.labelStep} 1",
                            isActive: true,
                            iconColor: Colors.green.shade900),
                        InstructionStep(
                            icon: Icons.person_sharp,
                            title: "${Languages.of(context)?.labelStep} 2",
                            isActive: true,
                            iconColor: Colors.green.shade900),
                        InstructionStep(
                            icon: Icons.lock_sharp,
                            title: "${Languages.of(context)?.labelStep} 3",
                            isActive: true,
                            iconColor: Colors.green.shade900),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${Languages.of(context)?.labelSignUpInEasySteps}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${Languages.of(context)?.labelNationalDigitalIdentityForAllCitizens}",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "1. ${Languages.of(context)?.labelScanYourID}",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      "2. ${Languages.of(context)?.labelVerifyDetails}",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      "3. ${Languages.of(context)?.labelSecureAccount}",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Stack(
                      children: [
                        // Block interaction
                        ModalBarrier(
                            dismissible: false, color: Colors.transparent),
                        // Loader indicator
                        Center(
                          child: CustomCircularProgress(),
                        ),
                      ],
                    )
                  : SizedBox()
            ]),
          ),
        ),
      ),
    );
  }
}
