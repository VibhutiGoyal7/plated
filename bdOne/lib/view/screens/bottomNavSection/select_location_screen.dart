import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:BDOne/model/db/BDOneDatabase.dart';
import 'package:BDOne/utils/Helper.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:BDOne/view/component/custom_button_component.dart';
import 'package:BDOne/view/component/listComponents/wrap_component.dart';
import 'package:BDOne/view/component/text_component.dart';
import 'package:BDOne/view/component/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/apis/api_response.dart';
import '../../../../theme/AppColor.dart';
import '../../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';

class SelectLocationScreen extends StatefulWidget {
  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  LatLng? currentLocation;
  LatLng? finalLocation = LatLng(0,0);
  bool? dashBoardKycStatus = true;

  final MapController _mapController = MapController();
  late BDOneDatabase database;
  static const maxDuration = Duration(seconds: 2);
  bool isLoading = false;
  bool isApiLoading = false;
  bool isInternetConnected = true;
  bool _isToggled = false;
  late double screenHeight;
  late double screenWidth;
  bool isDarkMode = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  late MainViewModel _viewModel;
  late ApiResponse apiResponse;
  List<LatLng> routePoints = [];
  String _locationMessage = "Fetching Route...";
  Timer? _timer;

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MainViewModel>(context, listen: false);
    _getCurrentLocation();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    DateTime? lastBackPressed;
    return Scaffold(
      body: RefreshIndicator(
        color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY_GREEN,
        onRefresh: () {
          print("Refresh");
          return Future.delayed(Duration(seconds: 2), () {
            //_fetchDashboardData();
          });
        },
        child: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: locationSearch()
                  //driverStatusWidget()
                  ),
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Container(
                          height: screenHeight * 0.84,
                          child: currentLocation != null
                              ? FlutterMap(
                                  mapController: _mapController,
                                  options: MapOptions(
                                    onTap: (tapPosition, point) => {},
                                    onMapReady: () {
                                      Future.delayed(
                                        Duration(milliseconds: 100),
                                        () {
                                          _mapController.move(
                                              currentLocation!, 13.0);
                                        },
                                      );
                                    },
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                                      retinaMode: true,
                                      subdomains: ['a', 'b', 'c'],
                                      additionalOptions: {
                                        'attribution':
                                            '© OpenStreetMap contributors, © CARTO',
                                      },
                                    ),
                                    /*PolylineLayer(
                    polylines: [

                        Polyline(
                          points: routePoints,
                          strokeWidth: 2,
                          color: Colors.blue,
                        ),
                      // Line from pickup location to drop location
                        Polyline(
                            points: [
                              pickupLocation,
                              finalLocation
                            ],
                            strokeWidth: 1,
                            color: Colors.black,
                            pattern: StrokePattern.dashed(
                                segments: [5, 3])),
                    ],
                  ),*/
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: currentLocation ??
                                              LatLng(0, 0),
                                          child: Icon(
                                            Icons.local_taxi_rounded,
                                            color: Colors.blue,
                                            size: 25.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ),
                        Positioned(
                          top: 10.0,
                          right: 10.0,
                          child: FloatingActionButton(
                            backgroundColor: AppColor.SECONDARY,
                            mini: true,
                            onPressed: () {
                              _getCurrentLocation();
                            },
                            child: Icon(
                              Icons.location_searching_outlined,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //isLoading ? CustomCircularProgress() : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget driverStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.4))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[100]),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Icon(Icons.local_taxi,
                size: 28,
              )),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    /*_toggleSwitch(!_isToggled);
                    setState(() {
                      isLoading = true;
                    });*/
                  },
                  child: Container(
                    width: 95,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: _isToggled ? Colors.green[800] : Colors.grey,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: _isToggled ? 58 : 4,
                          top: 3.5,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: CircleAvatar(
                              key: ValueKey<bool>(_isToggled),
                              radius: 16.5,
                              backgroundColor: Colors.white,
                              child: Icon(
                                _isToggled
                                    ? Icons.delivery_dining
                                    : Icons.close,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: _isToggled ? 10 : 50,
                          // Position the text accordingly
                          top: 13,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Text(
                              _isToggled ? 'Online' : 'Offline',
                              key: ValueKey<bool>(_isToggled),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /* currentServiceType != "" && currentServiceType != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: TextComponent(
                            text: "Service Type: $currentServiceType",
                            fontSize: 12,
                            isBold: true),
                      )
                    : SizedBox(),*/
                (dashBoardKycStatus == false)
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/ChooseDocScreen');
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 6,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Card(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                      //color: AppColor.WHITE,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.red, width: 0.8),
                                          bottom: BorderSide(
                                              color: Colors.red, width: 0.8),
                                          left: BorderSide(
                                              color: Colors.red, width: 0.8),
                                          right: BorderSide(
                                              color: Colors.red, width: 0.8))),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          Languages.of(context)!
                                              .labelKycNonVerified,
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Icon(
                                          Icons.do_not_disturb_on,
                                          size: 18,
                                          color: Colors.red,
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[100]),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Icon(
                Icons.notifications,
                size: 28,
              )),
        ],
      ),
    );
  }
/*
  void getDashBoardData() async {
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
    if (!isConnected) {
      setState(() {
        isLoading = true;
        isInternetConnected = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Languages.of(context)!.labelNoInternetConnection),
            duration: maxDuration,
          ),
        );
      });
    } else {
      if (mounted) {
        await _viewModel.fetchDashboardDetails();
        apiResponse = _viewModel.response;
        getDashboardData(context, apiResponse);
      }
    }
  }*/
/*
  Future<void> getDashboardData(
      BuildContext context, ApiResponse apiResponse) async {
    GetDashboardResponse? dashboardResponse =
        apiResponse.data as GetDashboardResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
      case Status.COMPLETED:

      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ToastComponent.showToast(
              context: context, message: "${apiResponse.message}");
        }
      case Status.INITIAL:
      default:
    }
  }*/

  void _launchPhoneDialer(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (phoneNumber.isNotEmpty) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }

  void _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      print('Current location: ${position.latitude}, ${position.longitude}');
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });

      LocationData? locationData = await LocationSearch.show(
          context: context,
          mode: Mode.fullscreen
      );
      ToastComponent.showToast(context: context, message: "${locationData?.address}", duration: maxDuration);
      print("Locations: : : ${locationData?.address}");

    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        // Permissions are denied, show an error
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      // Permissions are denied forever, handle accordingly
      throw Exception('Location permissions are permanently denied.');
    }

    // Retrieve the current location
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Fetch route data from OpenRouteService
  Future<void> _fetchRoute(LatLng initialLoc, LatLng finalLoc) async {
    final String apiKey =
        '5b3ce3597851110001cf6248cf8b20620dbd42cdb89fb5d4c3639b99';
    final String url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${initialLoc.longitude},${initialLoc.latitude}&end=${finalLoc.longitude},${finalLoc.latitude}';

    try {
      print(url);
      final response = await http.get(Uri.parse(url));
      print("response.status :: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coordinates =
            data['features'][0]['geometry']['coordinates'] as List;

        List<LatLng> route =
            coordinates.map<LatLng>((e) => LatLng(e[1], e[0])).toList();

        setState(() {
          routePoints = route;
          _locationMessage = "Route fetched successfully!";
          print(_locationMessage);
        });
      } else {
        setState(() {
          _locationMessage = "Failed to fetch route!";
        });
        print(_locationMessage);
      }
    } catch (e) {
      setState(() {
        _locationMessage = "Error: $e";
      });
      print(_locationMessage);
    }
  }

  void adjustMapView() {
    // Create bounds for the points
    LatLngBounds bounds = LatLngBounds(currentLocation ?? LatLng(0, 0), finalLocation ?? LatLng(0, 0));
    bounds.extend(currentLocation!);

    LatLng center = bounds.center;

    // Adjust the latitude to move the map view slightly upwards
    double adjustedLatitude = center.latitude - 0.02;
    LatLng adjustedCenter = LatLng(adjustedLatitude, center.longitude);

    // Adjust zoom to fit the bounds
    double fitZoomLevel = 12;

    // Move the map to the adjusted center
    _mapController.move(adjustedCenter, fitZoomLevel);
  }

  Future<void> _searchLocation(String query) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _searchResults = json.decode(response.body);
      });
    } else {
      print('Error: ${response.body}');
    }
  }

  @override
  Widget locationSearch() {
    return Container(
      height: 200,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: _searchLocation,
              onChanged: _searchLocation,
              decoration: InputDecoration(
                hintText: 'Search location...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  title: Text(result['display_name']),
                  subtitle: Text(
                      'Lat: ${result['lat']}, Lon: ${result['lon']}'),
                  onTap: () {
                    setState(() {
                      currentLocation = LatLng(double.parse(result['lat']), double.parse(result['lon']));
                    });
                    Future.delayed(
                      Duration(milliseconds: 100),
                          () {
                        _mapController.move(
                            currentLocation!, 13.0);
                      },
                    );
                    print('Selected: ${result['display_name']}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

