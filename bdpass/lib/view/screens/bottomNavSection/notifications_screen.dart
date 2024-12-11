import 'dart:async';

import 'package:BDPass/languageSection/Languages.dart';
import 'package:BDPass/model/db/BDPassDatabase.dart';
import 'package:BDPass/model/db/dao.dart';
import 'package:BDPass/theme/AppColor.dart';
import 'package:BDPass/view/component/custom_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/notificationListResponse.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/ShimmerList.dart';
import '../../component/connectivity_service.dart';
import '../../component/fixed_header_delegate.dart';
import '../../component/search_component.dart';
import 'history_screen.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var imageUrl;
  late double screenWidth;
  late double screenHeight;
  late BDPassDatabase database;
  late NotificationDao notificationDao;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<NotificationDetails> generalNotificationList = [
    NotificationDetails(
        status: "Expired",
        date: "18 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Request for sharing"),
    NotificationDetails(
        status: "Shared",
        date: "19 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Request for sharing"),
    NotificationDetails(
        status: "Expired",
        date: "19 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Request for sharing"),
    NotificationDetails(
        status: "Shared",
        date: "20 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Request for sharing"),
    NotificationDetails(
        status: "Shared",
        date: "20 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Request for sharing"),
    NotificationDetails(
        status: "Expired",
        date: "21 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Request for sharing"),
    NotificationDetails(
        status: "Shared",
        date: "20 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Request for sharing"),
    NotificationDetails(
        status: "Expired",
        date: "21 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Request for sharing"),
  ];

  late ScrollController _scrollController;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  final _numberOfPostsPerRequest = 20;
  Future<void>? _fetchDataFuture;
  static const maxDuration = Duration(seconds: 2);

  late bool isDarkMode;
  bool isSearch = false;
  bool _isCollapsed = false;
  bool isLoading = false;
  bool isDataAvail = true;
  final ConnectivityService _connectivityService = ConnectivityService();
  bool isInternetConnected = true;
  late Timer _showDialogTimer;
  bool _dialogVisible = false;

  void initState() {
    super.initState();
    imageUrl = "";
    intializeDatabase();
    _scrollController = ScrollController();
    _scrollController.addListener(_generalLoadMore);
/*    _scrollController.addListener(() {
      final isCollapsed = _scrollController.offset > 100; // Adjust threshold
      if (isCollapsed != _isCollapsed) {
        setState(() {
          _isCollapsed = isCollapsed;
        });
      }
    });*/
    _fetchDataFuture = _fetchData(_currentPage, false);
  }

  void _showDialog(BuildContext context, NotificationDetails data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.heading}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${data.date}",
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
            content: Text(
              "${data.detail}",
              style: TextStyle(fontSize: 13),
            ));
      },
    );
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

  void _toggleCollapse() {
    if (_isCollapsed) {
      // Scroll to the top to expand
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Scroll to the collapse threshold
      _scrollController.animateTo(
        200.0, // Expanded height
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
        body: Stack(
      children: [
        AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
              statusBarBrightness:
                  isDarkMode ? Brightness.dark : Brightness.light,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  isDarkMode ? Brightness.light : Brightness.dark),
          child: FutureBuilder(
            future: _fetchDataFuture,
            builder: (context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CustomLoader());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error loading data"));
              }

              // Group notifications by date
              Map<String, List<NotificationDetails>> groupedNotifications =
                  groupNotificationsByDate(generalNotificationList);
              List<String> dates = groupedNotifications.keys.toList();
              int i = 0;

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  CupertinoSliverNavigationBar(
                    largeTitle: Text(
                      "${Languages.of(context)?.labelNotification}",
                      style: TextStyle(
                        color: isDarkMode? Colors.white : AppColor.TEXT_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    middle: Text(
                      "${Languages.of(context)?.labelNotification}",
                      style: TextStyle(fontSize: 22,
                          color: isDarkMode? Colors.white : AppColor.TEXT_COLOR),
                    ),
                    backgroundColor:isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR,
                    alwaysShowMiddle: false,
                    leading: SizedBox(),
                  ),

                  // Your Fixed Header - SliverPersistentHeader

                  SliverPersistentHeader(
                    pinned: isSearch ? true : false,
                    // Keeps the header fixed at the top when scrolling
                    delegate: FixedHeaderDelegate(
                      child: Container(
                        color: isDarkMode
                            ? AppColor.DARK_BG_COLOR
                            : AppColor.BG_COLOR,
                        // Background color for the fixed header
                        // Background color for the fixed header
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: SearchComponent(
                            width: 1,
                            screenWidth: screenWidth,
                            isDarkMode: isDarkMode,
                            searchController: _searchController,
                            onChanged: () {}),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: !isDataAvail ? _buildNoDataScreen() : SizedBox(),
                  ),

                  !isDataAvail
                      ? SliverToBoxAdapter(
                          child: SizedBox(),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              String date = dates[index];
                              List<NotificationDetails> notificationsForDate =
                                  groupedNotifications[date]!;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*Text(
                                        date,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),*/
                                    ...notificationsForDate
                                        .asMap()
                                        .entries
                                        .map((notification) {
                                      i++;
                                      return generalNotificationItem(
                                          notification.value,
                                          i /*notification.key*/);
                                    }).toList(),
                                  ],
                                ),
                              );
                            },
                            childCount: dates.length,
                          ),
                        ),
                  if (_isLoadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 65,
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
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
              Icons.notification_important_outlined,
              size: 40,
              color: AppColor.PRIMARY,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "No notifications yet",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "You have no notification right now, please come back later.",
              style: TextStyle(),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget generalNotification() {
    return Container(
      height: screenHeight * 0.74,
      child: isInternetConnected && !isLoading
          ? checkListEmpty(generalNotificationList)
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
                          groupNotificationsByDate(generalNotificationList);
                      List<String> dates = groupedNotifications.keys.toList();
                      int i = 0;

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: dates.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == dates.length) {
                            return Center(child: CustomLoader());
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
                                  i++;
                                  return generalNotificationItem(
                                      notification.value,
                                      i /*notification.key*/);
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
                    "${Languages.of(context)?.labelNoNotifications}",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget generalNotificationItem(NotificationDetails data, int index) {
    return GestureDetector(
      onLongPress: () => _showDialog(context, data),
      onLongPressUp: () {
        // Close the dialog when the user lifts their finger
        // ToastComponent.showToast(context: _scaffoldKey.currentContext!, message: "message");
        Navigator.of(_scaffoldKey.currentContext!, rootNavigator: true).pop();
      },
      child: Center(
        child: Container(
          width: screenWidth,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: index % 2 == 0
                ? isDarkMode
                    ? AppColor.DARK_CARD_COLOR
                    : Colors.white
                : isDarkMode
                    ? Colors.black38
                    : Colors.grey[100],
            border: Border(
              bottom: BorderSide(
                  color: isDarkMode ? Colors.grey.shade700 : Colors.black,
                  width: 0.22),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data.status}",
                      style: TextStyle(fontSize: 10, color: AppColor.PRIMARY),
                    ),
                    Text(
                      "${data.heading}",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text("${data.detail}",
                        style: TextStyle(
                            fontSize: 11,
                            color: isDarkMode ? Colors.grey : Colors.black54)),
                    Text(
                      "${data.date}",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 15,
                )
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
