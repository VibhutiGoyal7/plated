import 'package:BDOne/languageSection/Languages.dart';
import 'package:BDOne/model/db/BDOneDatabase.dart';
import 'package:BDOne/model/db/dao.dart';
import 'package:BDOne/theme/AppColor.dart';
import 'package:BDOne/utils/Util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/notificationListResponse.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/shimmerComponents/ShimmerList.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var imageUrl;
  late double screenWidth;
  late double screenHeight;
  late BDOneDatabase database;
  late NotificationDao notificationDao;
  bool isDataAvail = true;
  bool isPinVerified = false;
  int selectedMonth = DateTime.now().month; // Current month
  int selectedYear = DateTime.now().year;
  List<NotificationDetails> generalNotificationList = [
    NotificationDetails(
        status: "Expired",
        date: "18 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Login Transactions"),
    NotificationDetails(
        status: "Shared",
        date: "19 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Login Transactions"),
    NotificationDetails(
        status: "Expired",
        date: "20 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Login Transactions"),
    NotificationDetails(
        status: "Shared",
        date: "21 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Login Transactions"),
    NotificationDetails(
        status: "Shared",
        date: "22 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Login Transactions"),
    NotificationDetails(
        status: "Expired",
        date: "23 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Login Transactions"),
    NotificationDetails(
        status: "Shared",
        date: "24 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Login Transactions"),
    NotificationDetails(
        status: "Expired",
        date: "25 Oct 2024",
        detail: "Emirate Telecommunication Corporation",
        heading: "Login Transactions"),
    NotificationDetails(
        status: "Expired",
        date: "26 Oct 2024",
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
        child: SafeArea(
          bottom: false,
          minimum: EdgeInsets.only(bottom: 70),
          child: Scaffold(
              body: Stack(children: [
                      AnnotatedRegion<SystemUiOverlayStyle>(
                          value: SystemUiOverlayStyle(
                            statusBarColor: Colors.transparent,
                            statusBarIconBrightness:
                                isDarkMode ? Brightness.light : Brightness.dark,
                            statusBarBrightness:
                                isDarkMode ? Brightness.dark : Brightness.light,
                          ),
                          child: FutureBuilder(
                            future: _fetchDataFuture,
                            builder: (context, AsyncSnapshot<void> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: CustomCircularProgress());
                              }

                              if (snapshot.hasError) {
                                return Center(
                                    child: Text("Error loading data"));
                              }

                              // Group notifications by date
                              Map<String, List<NotificationDetails>>
                                  groupedNotifications =
                                  groupHistoryByDate(
                                      generalNotificationList);
                              List<String> dates =
                                  groupedNotifications.keys.toList();
                              int i = 0;

                              return CustomScrollView(
                                controller: _scrollController,
                                slivers: [
                                  CupertinoSliverNavigationBar(
                                    largeTitle: Text(
                                      "${Languages.of(context)?.labelHistory}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode
                                              ? Colors.white
                                              : AppColor.TEXT_COLOR),
                                    ),
                                    middle: Text(
                                      "${Languages.of(context)?.labelHistory}",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: isDarkMode
                                              ? Colors.white
                                              : AppColor.TEXT_COLOR),
                                    ),
                                    backgroundColor: isDarkMode
                                        ? AppColor.DARK_BG_COLOR
                                        : AppColor.BG_COLOR,
                                    // Control the color
                                    trailing: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            _showDatePicker();
                                          },
                                          child: Icon(
                                            Icons.filter_alt_outlined,
                                            color: AppColor.PRIMARY,
                                            size: 26,
                                          )),
                                    ),
                                    alwaysShowMiddle: false,
                                    leading: SizedBox(),
                                    border:
                                        Border.all(color: Colors.transparent),
                                  ),
                                  /*  SliverLayoutBuilder(
                                builder: (BuildContext context, constraints) {
                                  final scrolled = constraints.scrollOffset > 0;
                                  return SliverAppBar(
                                    snap: false,
                                    pinned: true,
                                    floating: false,
                                    expandedHeight: 90.0,
                                    // Adjust the expanded height
                                    flexibleSpace: FlexibleSpaceBar(
                                      background: Container(
                                        color: AppColor.BG_COLOR,
                                      ),
                                      centerTitle: false,
                                      titlePadding: EdgeInsets.all(16),
                                      collapseMode: CollapseMode.parallax,
                                      title: Text(
                                        "${Languages.of(context)?.labelHistory}",
                                        style: TextStyle(
                                          color: AppColor.TEXT_COLOR,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    backgroundColor: AppColor.WHITE,
                                    //foregroundColor: AppColor.BG_COLOR,
                                    systemOverlayStyle: SystemUiOverlayStyle(
                                      statusBarColor: Colors.red, // Transparent status bar
                                      statusBarBrightness: Brightness.dark, // Text color in status bar (dark/light)
                                      statusBarIconBrightness: Brightness.light, // Status bar icons color
                                    ),
                                    leading: SizedBox(),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.filter_alt_outlined,
                                              color: AppColor.PRIMARY,
                                            )),
                                      )
                                    ],
                                  );
                                },
                              ),*/

                                  SliverToBoxAdapter(
                                    child: !isDataAvail
                                        ? _buildNoDataScreen()
                                        : SizedBox(),
                                  ),
                                  !isDataAvail
                                      ? SliverToBoxAdapter(
                                          child: SizedBox(),
                                        )
                                      : SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                              String date = dates[index];
                                              List<NotificationDetails>
                                                  historyForDate =
                                                  groupedNotifications[date]!;

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        date,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 11),
                                                      ),
                                                    ),
                                                    ...historyForDate
                                                        .asMap()
                                                        .entries
                                                        .map((history) {
                                                      i++;
                                                      return historyItem(
                                                          history.value,
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
                                        child: Center(
                                            child: CircularProgressIndicator()),
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
                          )
                       ),
                    ])),
        ),
      ),
    );
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

  Widget generalHistory() {
    return Container(
      height: screenHeight * 0.78,
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
                          groupHistoryByDate(generalNotificationList);
                      List<String> dates = groupedNotifications.keys.toList();

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: dates.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == dates.length) {
                            return Center(child: CustomCircularProgress());
                          }
                          String date = dates[index];
                          List<NotificationDetails> historyForDate =
                              groupedNotifications[date]!;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    date,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11),
                                  ),
                                ),
                                ...historyForDate
                                    .asMap()
                                    .entries
                                    .map((history) {
                                  return historyItem(
                                      history.value, history.key);
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

  Map<String, List<NotificationDetails>> groupHistoryByDate(
      List<NotificationDetails> history) {
    Map<String, List<NotificationDetails>> groupedHistory = {};

    for (var item in history) {
      String date = "${item.date}";
      if (!groupedHistory.containsKey(date)) {
        groupedHistory[date] = [];
      }
      groupedHistory[date]!.add(item);
    }
    return groupedHistory;
  }

  Widget historyItem(NotificationDetails data, int index) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/LoginTransactionScreen");
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10),
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
                  Icon(Icons.lock),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "${data.heading}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 13,
                  )
                ],
              ),
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

  void _showDatePicker() {
    showModalBottomSheet(
      backgroundColor: isDarkMode ? AppColor.DARK_CARD_COLOR : AppColor.LIGHT_CARD_COLOR,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 280,
          child: Column(
            children: [
              // Header with Cancel and Done buttons

              Expanded(
                child: Row(
                  children: [
                    // Month Picker
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedMonth - 1,
                        ),
                        itemExtent: 52.0,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedMonth = index + 1;
                          });
                        },
                        children: List<Widget>.generate(12, (int index) {
                          return Center(
                            child: Text(
                              _getMonthName(index + 1),
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }),
                      ),
                    ),
                    // Year Picker
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedYear - 2020,
                        ),
                        itemExtent: 52.0,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedYear = 2020 + index;
                          });
                        },
                        children: List<Widget>.generate(10, (int index) {
                          return Center(
                            child: Text(
                              (2020 + index).toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }),
                      ),
                    ),

                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context), // Close on cancel
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Process the selected date here
                        print("Selected Month: $selectedMonth");
                        print("Selected Year: $selectedYear");
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                ],
              ),
            ],
          ),
        );
      },
      isScrollControlled: true, // Makes the bottom sheet full height
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  Future<void> intializeDatabase() async {
    database = await $FloorBDOneDatabase
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
