import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/utils/Helper.dart';
import 'package:BDPass/view/component/custom_button_component.dart';
import 'package:BDPass/view/screens/authSection/instruction_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/countryListResponse.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  PageController _pageController = PageController();
  bool isLoading = false;
  bool isInstruction = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  List<CountryData> countryList = [];
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    /* _controller = VideoPlayerController.asset(
      'assets/video.mp4',
    )
      ..initialize().then((_) {
        // Ensure the first frame is shown
        setState(() {
          _controller.setLooping(true); // Enable seamless looping
          _controller.play(); // Start playing immediately
        });
      });*/
    //_fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*_controller.value.isInitialized
                    ? SizedBox(
                  height: screenHeight*0.5,
                  child: FittedBox(
                    fit: BoxFit.cover, // Make the video fill the screen
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
                    : SizedBox(),*/
                Image(
                  height: screenHeight * 0.08,
                  image: AssetImage(isDarkMode
                      ? "assets/app_logo_dark.png"
                      : "assets/app_logo.png"),
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "${Languages.of(context)?.labelCreateBDPassAccount}",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "${Languages.of(context)?.labelNationalDigitalIdentityAndSignatureSol}",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                /*Image(
                  //height: screenHeight * 0.35,
                  image: AssetImage(isDarkMode
                      ? "assets/app_logo_dark.png"
                      : "assets/app_logo.png"),
                  fit: BoxFit.cover,
                ),*/
                SizedBox(
                  height: 70,
                ),
                Center(
                    child: CustomButtonComponent(
                        text: "${Languages.of(context)?.labelCreateNewAccount}",
                        screenWidth: screenWidth,
                        isDarkMode: isDarkMode,
                        onTap: () {
                          setState(() {
                            isInstruction = true;
                          });
                        })),
                Center(
                  child: _buildExistingAccFooter(
                      isDarkMode: isDarkMode,
                      context: context,
                      text:
                          "${Languages.of(context)?.labelHaveAnExistingAccount}",
                      onTap: () {
                        // Navigator.pushNamed(context, '/SliderScreen');
                      }),
                ),
                SizedBox(
                  height: 52,
                )
              ],
            ),
          ),
          isInstruction
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isInstruction = false;
                    });
                    Navigator.pushNamed(context, "/TermsConditionsScreen");
                  },
                  child: InstructionScreen())
              : SizedBox(),
          isLoading
              ? Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(dismissible: false, color: Colors.transparent),
                    // Loader indicator
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : SizedBox()
        ]),
      ),
    );
  }

  Widget _buildExistingAccFooter(
      {required BuildContext context,
      required String text,
      required bool isDarkMode,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.94,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDarkMode ? Colors.white : Colors.black, width: 0.8),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }

  void _fetchData() async {
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
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchCountryList("api/v1/app/customers/country_list");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getCountryList(context, apiResponse);
    }
  }

  Widget getCountryList(BuildContext context, ApiResponse apiResponse) {
    CountryListResponse? countryListResponse =
        apiResponse.data as CountryListResponse?;
    var message = apiResponse.message.toString();
    print("message ${message}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${countryListResponse?.countries?[1].name}");

        countryList = countryListResponse!.countries!;
        Helper.saveCountryList(countryList);
        //selectedItem = "${countryListResponse?.countries?[0].flagImageUrl}";

        print("countriess ${countryList}");

        //_showPicker(context: context);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("countriess ${countryList}");
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
}
