import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../model/response/requestListResponse.dart';
import '../../../../../theme/AppColor.dart';
import '../../../../utils/Util.dart';
import '../../../component/custom_text_component.dart';
import '../../../component/text_component.dart';

class RequestOverviewScreen extends StatefulWidget {
  final RequestDetails? data;

  RequestOverviewScreen({required this.data});

  @override
  _RequestOverviewScreenState createState() => _RequestOverviewScreenState();
}

class _RequestOverviewScreenState extends State<RequestOverviewScreen> {
  bool isDarkMode = false;
  bool isLoading = false;
  late double screenWidth;
  late double screenHeight;
  final MapController _mapController = MapController();
  RequestDetails? requestDetails = RequestDetails();
  List<LatLng> routePoints = [];
  String _locationMessage = "Fetching Route...";

  @override
  void initState() {
    super.initState();
    requestDetails = widget.data;
    _fetchRoute(
        LatLng(double.parse("${requestDetails?.pickUpLatitude}"),
            double.parse("${requestDetails?.pickUpLongitude}")),
        LatLng(double.parse("${requestDetails?.dropLatitude}"),
            double.parse("${requestDetails?.dropLongitude}")));
  }

  Future<void> _openMap(
      String latitude, String longitude, String address) async {
    final Uri url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}&query_place_id=${address}");

    if (!await canLaunchUrl(url)) {
      throw Exception("Could not open map.");
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isTablet = getIsTablet(context, screenWidth, screenHeight);
    return GestureDetector(
      onTap: () => hideKeyBoard(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    "Request Details",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? AppColor.WHITE : AppColor.BLACK,
                        fontSize: 26),
                  ),
                  middle: Text(
                    "Request Details",
                    style: TextStyle(
                        fontSize: 22,
                        color: isDarkMode ? AppColor.WHITE : AppColor.BLACK),
                  ),
                  backgroundColor:
                      isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.WHITE,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: isDarkMode ? AppColor.WHITE : AppColor.BLACK,
                      size: 18,
                    ),
                  ),
                  alwaysShowMiddle: false,
                  border: Border.all(color: Colors.transparent, width: 0),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 8,
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextComponent(
                              text: "Date & Time", fontSize: 12, isBold: false),
                          TextComponent(
                              text:
                                  "${convertTime("${requestDetails?.createdAt}")}",
                              fontSize: 16,
                              isBold: true),
                        ],
                      )
                    ],
                  ),
                )),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: screenWidth * 0.88,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isDarkMode ? AppColor.WHITE : AppColor.BLACK,
                            width: 0.3)),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_pin,
                              size: 22,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: Text(
                              "${requestDetails?.pickupAddress ?? ""}",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.visible,
                            )),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                _openMap(
                                    requestDetails?.pickUpLatitude ?? "",
                                    requestDetails?.pickUpLongitude ?? "",
                                    requestDetails?.pickupAddress ?? "");
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.3),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Icon(
                                  Icons.share_location,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth * 0.18,
                              height: 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColor.PRIMARY_GREEN,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            CustomTextComponent(
                              text: "TO",
                              fontSize: 12,
                              isBold: false,
                              fontColor: AppColor.PRIMARY_GREEN,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                              width: screenWidth * 0.18,
                              height: 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColor.PRIMARY_GREEN,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.my_location,
                              size: 20,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child:
                                    Text("${requestDetails?.dropAddress ?? ""}",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.visible)),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                _openMap(
                                    requestDetails?.dropLatitude ?? "",
                                    requestDetails?.dropLongitude ?? "",
                                    requestDetails?.dropAddress ?? "");
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.3),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Icon(Icons.share_location),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 18,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextComponent(
                                text: "Total Fare",
                                fontSize: 12,
                                isBold: false),
                            TextComponent(
                                text: "৳${requestDetails?.fare ?? ""}",
                                fontSize: 18,
                                isBold: true),
                          ],
                        ),
                        requestDetails?.distance != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextComponent(
                                      text: "Distance",
                                      fontSize: 12,
                                      isBold: false),
                                  TextComponent(
                                      text: "${requestDetails?.distance ?? ""}",
                                      fontSize: 18,
                                      isBold: true),
                                ],
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: screenHeight * 0.25,
                    child: requestDetails?.pickUpLatitude != null
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
                                      point: LatLng(
                                          double.parse(
                                              "${requestDetails?.pickUpLatitude}"),
                                          double.parse(
                                              "${requestDetails?.pickUpLongitude}")),
                                      child: Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.red,
                                        size: 30.0,
                                      )),
                                  Marker(
                                      point: LatLng(
                                          double.parse(
                                              "${requestDetails?.dropLatitude}"),
                                          double.parse(
                                              "${requestDetails?.dropLongitude}")),
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
                )
              ],
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
                        child: CircularProgressIndicator(
                          color:
                              isDarkMode ? AppColor.WHITE : AppColor.SECONDARY,
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
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

  void adjustMapView() {
    // Create bounds for the points
    LatLngBounds bounds = LatLngBounds(
        LatLng(double.parse("${requestDetails?.pickUpLatitude}"),
            double.parse("${requestDetails?.pickUpLongitude}")),
        LatLng(double.parse("${requestDetails?.dropLatitude}"),
            double.parse("${requestDetails?.dropLongitude}")));
    //bounds.extend(currentLocation!);

    LatLng center = bounds.center;

    // Adjust the latitude to move the map view slightly upwards
    double adjustedLatitude = center.latitude - 0.02;
    LatLng adjustedCenter = LatLng(center.latitude, center.longitude);

    // Adjust zoom to fit the bounds
    double fitZoomLevel = 13;

    // Move the map to the adjusted center
    _mapController.move(adjustedCenter, fitZoomLevel);
  }
}
