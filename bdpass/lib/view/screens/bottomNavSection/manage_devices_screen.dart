import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/model/db/BDPassDatabase.dart';
import 'package:BDPass/model/db/dao.dart';
import 'package:BDPass/theme/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/notificationListResponse.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/ShimmerList.dart';
import '../../component/connectivity_service.dart';

class ManageDevicesScreen extends StatefulWidget {
  @override
  _ManageDevicesScreenState createState() => _ManageDevicesScreenState();
}

class _ManageDevicesScreenState extends State<ManageDevicesScreen> {
  var imageUrl;
  late double screenWidth;
  late double screenHeight;
  late BDPassDatabase database;
  late NotificationDao notificationDao;
  bool isDataAvail = false;
  List<NotificationDetails> getLoginDeviceList = [
    NotificationDetails(
        status: "Expired",
        date: "18 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Login Transactions"),
  ];

  final _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  final _numberOfPostsPerRequest = 20;
  Future<void>? _fetchDataFuture;
  static const maxDuration = Duration(seconds: 2);

  late bool isDarkMode;

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  bool isInternetConnected = true;

  void initState() {
    super.initState();
    imageUrl = "";
    intializeDatabase();
    _scrollController.addListener(_generalLoadMore);

    _fetchDataFuture = _fetchData(_currentPage, false);
  }

  runApi(int? index) {
    _currentPage = 1;
    _scrollController.addListener(_generalLoadMore);
    //_fetchData(_currentPage, true);
    _fetchDataFuture = _fetchData(_currentPage, false);
    //_fetchPaginatedNotifications(selectedNotificationType, _currentPage);
  }

  void _generalLoadMore() async {
    if (!_isLoadingMore &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
      await _fetchData(_currentPage, true);
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _fetchData(int pageKey, bool isScroll) async {
    print("Fetch Data");
    try {
      setState(() {
        //_isLoadingMore = true;
      });
      bool isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        setState(() {
          isLoading = false;
          isInternetConnected = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('${Languages.of(context)?.labelNoInternetConnection}'),
              duration: maxDuration,
            ),
          );
        });
      } else {
        /*SortingDetail sorting = SortingDetail(createdAt: "desc");
        NotificationListRequest request = NotificationListRequest(
          pageNo: pageKey,
          pageSize: _numberOfPostsPerRequest,
          notificationType: selectedNotificationType,
          sorting: sorting,
        );*/
        /* await Provider.of<MainViewModel>(context, listen: false)
            .notificationListData("api/v1/app/notifications/list", request);*/
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await getNotificationData(context, apiResponse, pageKey, isScroll);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> getNotificationData(BuildContext context,
      ApiResponse apiResponse, int pageKey, bool isScroll) async {
    NotificationListResponse? notificationListResponse =
        apiResponse.data as NotificationListResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return;
      case Status.COMPLETED:
        final newItems = notificationListResponse?.data ?? [];

        await database.notificationDao.insertNotifications(newItems);

        //await _fetchPaginatedNotifications(selectedNotificationType, pageKey);
        // Fetch paginated data from the local database

        return;
      case Status.ERROR:
        // Handle error
        return;
      case Status.INITIAL:
      default:
        return;
    }
  }

/*

  Future<void> _fetchPaginatedNotifications(String type, int pageKey) async {
    final notifications = await database.notificationDao.fetchNotifications(
        type,
        _numberOfPostsPerRequest,
        (pageKey - 1) * _numberOfPostsPerRequest);

    setState(() {
        if (pageKey == 1) {
          generalNotificationList.clear();
        }
        generalNotificationList.addAll(notifications);

    });
  }
*/

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, top: 20, bottom: 5, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 8.0),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "${Languages.of(context)?.labelManageDevices}",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            isDataAvail ? _buildNoDataScreen() : generalLoginDeviceList(),
          ],
        ),
      ),
    ));
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
              Icons.devices,
              size: 45,
              color: AppColor.PRIMARY,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "No data found for selected month!",
              style: TextStyle(),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget generalLoginDeviceList() {
    return Container(
      height: screenHeight * 0.75,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: isInternetConnected && !isLoading
          ? checkListEmpty(getLoginDeviceList)
              ? FutureBuilder(
                  future: _fetchDataFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error loading data'));
                    } else {
                      // Group transactions by date
                      Map<String, List<NotificationDetails>>
                          groupedNotifications =
                          groupNotificationsByDate(getLoginDeviceList);
                      List<String> dates = groupedNotifications.keys.toList();

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: dates.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == dates.length) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: isDarkMode
                                  ? AppColor.WHITE
                                  : AppColor.PRIMARY,
                            ));
                          }
                          String date = dates[index];
                          List<NotificationDetails> notificationsForDate =
                              groupedNotifications[date]!;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...notificationsForDate
                                    .asMap()
                                    .entries
                                    .map((notification) {
                                  return generalLoginDeviceItem(
                                      notification.value, notification.key);
                                }).toList(),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                )
              : Center(
                  child: Text(
                    "${Languages.of(context)?.labelNoData}",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
              child: ShimmerList(itemCount: 2),
            ),
    );
  }

  Map<String, List<NotificationDetails>> groupNotificationsByDate(
      List<NotificationDetails> notifications) {
    Map<String, List<NotificationDetails>> groupedNotifications = {};

    for (var notification in notifications) {
      String date = "${notification.date}";
      if (!groupedNotifications.containsKey(date)) {
        groupedNotifications[date] = [];
      }
      groupedNotifications[date]!.add(notification);
    }
    return groupedNotifications;
  }

  Widget generalLoginDeviceItem(NotificationDetails data, int index) {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        color: isDarkMode ? AppColor.DARK_CARD_COLOR : Colors.grey[100],
        child: Container(
          width: screenWidth,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
              /*color: index % 2 == 0
                ? Colors.white
                : Colors.grey[100],*/
              ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.phone_iphone),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Iphone",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Recently Logged in @07:26pm",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkListEmpty(List<NotificationDetails> list) {
    bool isListEmpty = false;

    isListEmpty = list.isNotEmpty;

    return isListEmpty;
  }

  Future<void> intializeDatabase() async {
    database = await $FloorBDPassDatabase
        .databaseBuilder('payorio_database.db')
        .build();

    notificationDao = database.notificationDao;
    //_fetchPaginatedNotifications(selectedNotificationType, _currentPage);
  }
}

class NotificationDetails {
  String? status;
  String? heading;
  String? detail;
  String? date;

  NotificationDetails({
    this.status,
    this.heading,
    this.detail,
    this.date,
  });
}
