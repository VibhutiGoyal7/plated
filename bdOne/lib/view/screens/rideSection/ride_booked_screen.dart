import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:BDOne/model/db/BDOneDatabase.dart';
import 'package:BDOne/model/response/driverStatusResponse.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:BDOne/view/component/custom_button_component.dart';
import 'package:BDOne/view/component/text_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_broadcasts/flutter_broadcasts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../model/apis/api_response.dart';
import '../../../../theme/AppColor.dart';
import '../../../../view_model/main_view_model.dart';
import '../../../languageSection/Languages.dart';
import '../../../model/request/driverCurrentLocRequest.dart';
import '../../component/accepted_request_widget.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/session_expired_dialog.dart';

class RideBookedScreen extends StatefulWidget {
  final DriverStatusResponse? data;

  RideBookedScreen({Key? key, this.data}) : super(key: key);

  @override
  _RideBookedScreenState createState() => _RideBookedScreenState();
}

class _RideBookedScreenState extends State<RideBookedScreen>
    with WidgetsBindingObserver {
  String? requestStatus = "";
  LatLng? currentLocation;
  bool? dashBoardKycStatus = true;
  LatLng pickupLocation = LatLng(30.699135, 76.723666);
  LatLng driverLocation = LatLng(0, 0);
  LatLng finalLocation = LatLng(30.72589, 76.75787);
  DriverStatusResponse acceptedRide = DriverStatusResponse();

  final MapController _mapController = MapController();
  late BDOneDatabase database;
  static const maxDuration = Duration(seconds: 2);
  bool isLoading = false;
  bool isApiLoading = false;
  bool isInternetConnected = true;
  bool isRideStarted = true;
  late double screenHeight;
  late double screenWidth;
  bool isDarkMode = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  BroadcastReceiver receiver = BroadcastReceiver(
    names: <String>[
      "de.kevlatus.flutter_broadcasts_example.demo_action",
    ],
  );
  late ApiResponse apiResponse;
  List<LatLng> routePoints = [];
  String _locationMessage = "Fetching Route...";
  bool isPipMode = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      acceptedRide = widget.data ?? DriverStatusResponse();
      pickupLocation = LatLng(double.parse("${acceptedRide.pickup_latitude}"),
          double.parse("${acceptedRide.pickup_longitude}"));
      finalLocation = LatLng(
          double.parse("${acceptedRide.destination_latitude}"),
          double.parse("${acceptedRide.destination_longitude}"));
      if (acceptedRide.driverCurrentLong != null) {
        driverLocation = LatLng(
            double.parse("${acceptedRide.driverCurrentLat}"),
            double.parse("${acceptedRide.driverCurrentLong}"));
      }
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:
          Brightness.light, // Light icons for the status bar
      //statusBarBrightness: Brightness.light,       // Status bar brightness (for iOS)
    ));
    _getCurrentLocation(null);
    //getDashBoardData();
    receiver.start();
    receiver.messages.listen((message) {
      print("BroadCast");
    });
    if(driverLocation != LatLng(0,0)) {
      _fetchRoute(driverLocation, pickupLocation);
    }
    rideStatusApi();
  }

  @override
  void dispose() {
    receiver.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushNamed(context, "/RideBottomNav");
      },
      child: Scaffold(
        body: isPipMode
            ? currentLocation != null
                ? FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      onTap: (tapPosition, point) => {},
                      onMapReady: () {
                        Future.delayed(
                          Duration(milliseconds: 100),
                          () {
                            adjustMapView();
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
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints,
                            strokeWidth: 2,
                            color: Colors.blue,
                          ),
                          // Line from pickup location to drop location
                          if (requestStatus == "accepted")
                            Polyline(
                                points: [pickupLocation, finalLocation],
                                strokeWidth: 1,
                                color: Colors.black,
                                pattern:
                                    StrokePattern.dashed(segments: [5, 3])),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: currentLocation ?? LatLng(0, 0),
                            child: Icon(
                              Icons.my_location_rounded,
                              color: Colors.black,
                              size: 25.0,
                            ),
                          ),
                          Marker(
                            point: driverLocation ?? LatLng(0, 0),
                            child: Icon(
                              Icons.local_taxi_rounded,
                              color: Colors.blue,
                              size: 25.0,
                            ),
                          ),
                          Marker(
                              point: pickupLocation,
                              child: Icon(
                                Icons.location_on_outlined,
                                color: Colors.red,
                                size: 30.0,
                              )),
                          Marker(
                              point: finalLocation,
                              child: Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 30.0,
                              )),
                        ],
                      ),
                    ],
                  )
                : SizedBox()
            : RefreshIndicator(
                color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY_GREEN,
                onRefresh: () {
                  print("Refresh");
                  return Future.delayed(Duration(seconds: 2), () {
                    //_fetchDashboardData();
                  });
                },
                child: Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Stack(
                            children: [
                              Container(
                                height: screenHeight,
                                child: currentLocation != null
                                    ? FlutterMap(
                                        mapController: _mapController,
                                        options: MapOptions(
                                          onTap: (tapPosition, point) => {},
                                          onMapReady: () {
                                            Future.delayed(
                                              Duration(milliseconds: 100),
                                              () {
                                                adjustMapView();
                                                /* _mapController.move(
                                                      currentLocation!,
                                                      13.0);*/
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
                                          PolylineLayer(
                                            polylines: [
                                              Polyline(
                                                points: routePoints,
                                                strokeWidth: 2,
                                                color: Colors.blue,
                                              ),
                                              // Line from pickup location to drop location
                                              if (requestStatus == "accepted")
                                                Polyline(
                                                    points: [
                                                      pickupLocation,
                                                      finalLocation
                                                    ],
                                                    strokeWidth: 1,
                                                    color: Colors.black,
                                                    pattern:
                                                        StrokePattern.dashed(
                                                            segments: [
                                                          5,
                                                          3
                                                        ])),
                                            ],
                                          ),
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
                                              Marker(
                                                  point: pickupLocation,
                                                  child: Icon(
                                                    Icons
                                                        .location_on_outlined,
                                                    color: Colors.red,
                                                    size: 30.0,
                                                  )),
                                              Marker(
                                                  point: finalLocation,
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: Colors.green,
                                                    size: 30.0,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ),
                              Container(
                                height: screenHeight,
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: AcceptedRequestWidget(
                                      isRideStarted: isRideStarted,
                                      data: acceptedRide ??
                                          DriverStatusResponse(),
                                      onCancelTap: () {
                                        RequestCancelDialog();
                                      },
                                      requestStatus: "${requestStatus}",
                                      onPhoneTap: () {
                                        _launchPhoneDialer(
                                            acceptedRide.phoneNumber ?? "");
                                      },
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 35),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Icon(Icons.arrow_back)),
                                    FloatingActionButton(
                                      backgroundColor: AppColor.PRIMARY_ACCENT,
                                      mini: true,
                                      onPressed: () {
                                        _getCurrentLocation(null);
                                      },
                                      child: Icon(
                                        Icons.location_searching_outlined,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // isLoading ? CustomCircularProgress() : SizedBox(),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> RequestCancelDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          icon: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close)),
          ),
          iconPadding: EdgeInsets.all(8),
          title: Text("Cancel Request"),
          content: TextComponent(
              text: "Are you sure you want to cancel the ongoing ride?",
              fontSize: 14,
              isBold: false),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButtonComponent(
                    text: "No",
                    width: screenWidth * 0.28,
                    textColor: Colors.white,
                    buttonColor: Colors.green[700] ?? Colors.green,
                    isDarkMode: isDarkMode,
                    borderRadius: 6,
                    verticalPadding: 10,
                    onTap: () {
                      Navigator.pop(context);
                    }),
                CustomButtonComponent(
                    text: "Yes",
                    width: screenWidth * 0.28,
                    textColor: Colors.white,
                    buttonColor: Colors.red[700] ?? Colors.red,
                    isDarkMode: isDarkMode,
                    verticalPadding: 10,
                    borderRadius: 6,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context,"/RideBottomNav");
                    }),
              ],
            ),
          ],
        );
      },
    );
  }

  void rideStatusApi() async {
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));

    if (!isConnected) {
      setState(() {
        isApiLoading = false;
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
        setState(() {
          isApiLoading = false;
        });
        DriverCurrentLocRequest request =
            DriverCurrentLocRequest(uniqueId: "${widget.data?.uniqueId}");
        await Provider.of<MainViewModel>(context, listen: false)
            .getDriverStatus(
                "/api/v1/customer_app/service_requests/get_driver_location",
                request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getRideStatusResponse(context, apiResponse);
      }
    }
  }

  Future<Widget> getRideStatusResponse(
      BuildContext context, ApiResponse apiResponse) async {
    DriverStatusResponse? response = apiResponse.data as DriverStatusResponse?;
    var message = apiResponse.message.toString();
    print("message ${response?.message}");
    setState(() {
      isApiLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        if (response?.rideStatus == "ride_start") {
          setState(() {
            isRideStarted = true;
          });
        } else {
          driverLocation = LatLng(
              double.parse("${acceptedRide.driverCurrentLat}"),
              double.parse("${acceptedRide.driverCurrentLong}"));
          _fetchRoute(driverLocation, pickupLocation);
          await Future.delayed(Duration(seconds: 10));
          rideStatusApi();
        }
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          print(apiResponse.message);
          if (receiver.isListening) {
            receiver.stop();
          }
          SessionExpiredDialog.showDialogBox(context: context);
        } else {}
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

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

  void _getCurrentLocation(bool? isAcceptedRideLocUpdate) async {
    try {
      Position position = await _determinePosition();
      print('Current location: ${position.latitude}, ${position.longitude}');
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
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
    LatLngBounds bounds = LatLngBounds(driverLocation, pickupLocation);
    //bounds.extend(currentLocation!);

    LatLng center = bounds.center;

    // Adjust the latitude to move the map view slightly upwards
    double adjustedLatitude = center.latitude - 0.02;
    LatLng adjustedCenter = LatLng(center.latitude, center.longitude);

    // Adjust zoom to fit the bounds
    double fitZoomLevel = 15;

    // Move the map to the adjusted center
    _mapController.move(adjustedCenter, fitZoomLevel);
  }
}
