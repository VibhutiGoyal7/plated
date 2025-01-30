import 'package:BDOne/languageSection/Languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/custom_circular_progress.dart';

class SelectServiceScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  SelectServiceScreen({Key? key, this.data}) : super(key: key);

  @override
  _VendorLocationScreenState createState() => _VendorLocationScreenState();
}

class _VendorLocationScreenState extends State<SelectServiceScreen> {
  //int franchiseId = 1;
  int franchiseId = 38;

  late double screenWidth;
  late double screenHeight;
  bool isLoading = false;
  bool isDarkMode = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  String selectedLocality = "";
  List<String> list = ["Travel", "Food", "Transportation"];
  var placeholderImage =
      'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    // _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: Container(
        /*decoration: BoxDecoration(
          gradient: RadialGradient (
            center: Alignment.center,
            radius: 0.8,
            focalRadius: 0.4,
            */ /*
            begin: Alignment.topLeft,
            // Start point of the gradient
            end: Alignment.bottomRight,
            // End point of the gradient*/ /*
            colors: [
              Colors.black45,
              Colors.black12,
              Colors.black45,
            ],
          ),
        ),*/
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 70),
                        Center(
                          child: Image(
                            height: screenHeight * 0.05,
                            image: AssetImage(isDarkMode
                                ? "assets/app_logo_dark.png"
                                : "assets/app_logo.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 30),
                        _buildServiceList(),
                        SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (isLoading)
              Stack(
                children: [
                  // Block interaction
                  ModalBarrier(dismissible: false, color: Colors.transparent),
                  // Loader indicator
                  Center(
                    child: CustomCircularProgress(),
                  ),
                ],
              )
          ],
        ),
      ),
    ));
  }

  Widget _buildServiceList() {
    return Container(
      child: SingleChildScrollView(
        child: Wrap(
            spacing: 6,
            // Horizontal space between items
            runSpacing: 8,
            // Vertical space between lines
            children: list.map((result) {
              //CategoryData? result = categories[index];
              return _buildCard(result);
            }).toList()),
      ),
    );
  }

  Widget _buildCard(String text) {
    return GestureDetector(
      onTap: () {
        if (text == "Food")
          Navigator.pushNamed(context, "/BottomNav");
        else if (text == "Travel")
          Navigator.pushNamed(context, "/TravelBottomNav");
        else
          Navigator.pushNamed(context, "/TransportationBottomNav");
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
        child: Stack(
          children: [
            Container(
              height: screenHeight * 0.16,
              width: screenWidth * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.5),
                child: Image(
                    image: AssetImage(text == "Food"
                        ? "assets/food_img.jpg"
                        : text == "Travel"
                            ? "assets/travel_img.jpg"
                            : "assets/transportation_img.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              height: screenHeight * 0.16,
              width: screenWidth * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  // Start point of the gradient
                  end: Alignment.centerRight,
                  // End point of the gradient
                  colors: [
                    Colors.black,
                    Colors.black54,
                    Colors.black54,
                    Colors.black45,
                    Colors.transparent,
                    Colors.transparent,
                  ],
                ),
                /* image: DecorationImage(
                      image: AssetImage(text == "Food"
                          ? "assets/food_img.jpg"
                          : text == "Travel"
                              ? "assets/travel_img.jpg"
                              : "assets/transportation_img.jpg"),fit: BoxFit.cover)*/
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
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
      await Future.delayed(Duration(
          milliseconds:
              2)); /*
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchVendors("/api/v1/vendors/${franchiseId}/get_stores");*/
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getVendorList(context, apiResponse);
    }
  }

  Widget getVendorList(BuildContext context, ApiResponse apiResponse) {
    /*   VendorListResponse? vendorListResponse =
        apiResponse.data as VendorListResponse?;*/
    var message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        /*   print("rwrwr ${vendorListResponse?.vendors?[0].businessName}");

        // countryList = countryListResponse!.countries!;
        //Helper.saveCountryList(vendorList);
        //selectedItem = "${countryListResponse?.countries?[0].flagImageUrl}";
        setState(() {
          vendorList = vendorListResponse!.vendors!;
        });*/

        //_showPicker(context: context);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
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
