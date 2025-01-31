import 'dart:convert';

import 'package:BDOne/theme/AppColor.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../model/response/driverStatusResponse.dart';
import '../../component/location_stop_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class RideBookedDetailScreen extends StatefulWidget {

  final DriverStatusResponse? data;

  RideBookedDetailScreen({Key? key, this.data}) : super(key: key);
  @override
  _RideBookedDetailScreenState createState() => _RideBookedDetailScreenState();
}

class _RideBookedDetailScreenState extends State<RideBookedDetailScreen> {
  late double screenWidth;
  late double screenHeight;
  bool isDataAvail = true;
  bool isPinVerified = false;
  LatLng? currentLocation = LatLng(30.701105, 76.737192);
  LatLng pickupLocation = LatLng(30.699135, 76.723666);
  LatLng driverLocation = LatLng(30.701105, 76.737192);
  LatLng finalLocation = LatLng(30.72589, 76.75787);
  DriverStatusResponse acceptedRide = DriverStatusResponse();
  final MapController _mapController = MapController();
  List<LatLng> routePoints = [];
  String _locationMessage = "Fetching Route...";
  late bool isDarkMode;

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
    _fetchRoute(pickupLocation, finalLocation);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushNamed(context, "/BottomNav");
      },
      child: GestureDetector(
        onTap: () {
          hideKeyBoard();
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: isDarkMode ? AppColor.BLACK : AppColor.WHITE,
              title: Text(
                "Booked Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
            ),
            body: SafeArea(
              bottom: false,
              minimum: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDestinationScreen(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    child: Text(
                      "Track on map",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.25,
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
                                  /*Polyline(
                                      points: [pickupLocation, finalLocation],
                                      strokeWidth: 1,
                                      color: Colors.black,
                                      pattern: StrokePattern.dashed(
                                          segments: [5, 3])),*/
                                ],
                              ),
                              MarkerLayer(
                                markers: [
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
                        : SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 4.0),
                    child: Text(
                      "Driver Details",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.5),
                              child: Image(
                                  height: 40,
                                  image: AssetImage("assets/address.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${acceptedRide.firstName ?? ""} ${acceptedRide.lastName ?? ""}",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                "${acceptedRide.phoneNumber ?? ""}",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: ()
                        {
                          _launchPhoneDialer(
                              acceptedRide.phoneNumber ?? "");
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(width: 0.5)),
                          child: Text(
                            "Contact",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.of(context)
                            .pushNamed("/RideBottomNav")
                      },
                      child: Container(
                        width: screenWidth * 0.8,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                        margin: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColor.PRIMARY_ACCENT),
                        child: Column(
                          children: [
                            Text(
                              "Complete",
                              style: TextStyle(
                                  color: AppColor.WHITE,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildDestinationScreen() {
    return IntrinsicHeight(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        constraints: BoxConstraints(minHeight: screenHeight * 0.26),
        decoration: BoxDecoration(
          color: AppColor.WHITE,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 0),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            LocationStopWidget(
              location: "${acceptedRide.pickup_address ?? ""}",
              isPickUp: true,
            ),
            LocationStopWidget(
              location: "${acceptedRide.destination_address ?? ""}",
              isPickUp: false,
            ),
            Container(
              height: 1,
              width: screenWidth * 0.85,
              color: Colors.grey[300],
              margin: EdgeInsets.only(top: 5, bottom: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               /* Row(
                  children: [
                    Icon(Icons.directions_car_filled),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${acceptedRide. ?? ""}",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "AK617",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        )
                      ],
                    ),
                  ],
                ),*/
                Text(
                  "৳${acceptedRide.estimatedFare ?? ""}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            )
          ],
        ),
      ),
    );
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

  void adjustMapView() {
    // Create bounds for the points
    LatLngBounds bounds = LatLngBounds(pickupLocation, finalLocation);
    //bounds.extend(currentLocation!);

    LatLng center = bounds.center;

    // Adjust the latitude to move the map view slightly upwards
    double adjustedLatitude = center.latitude - 0.02;
    LatLng adjustedCenter = LatLng(center.latitude, center.longitude);

    // Adjust zoom to fit the bounds
    double fitZoomLevel = 10;

    // Move the map to the adjusted center
    _mapController.move(adjustedCenter, fitZoomLevel);
  }

  Widget _buildNoDataScreen() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
            ),
            Icon(
              Icons.history,
              size: 45,
              color: Theme.of(context).focusColor,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "No data found!",
              style: TextStyle(fontSize: 12, color: Theme.of(context).focusColor,),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
