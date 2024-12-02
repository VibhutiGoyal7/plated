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
      value:
          isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 10,bottom: 5,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notification",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.menu)
                ],
              ),
            ),
            _buildSearch(),
            SizedBox(height: 4,),
            generalNotification(),
          ],
        ),
      ),
    ));
  }

  Widget generalNotification() {
    return Container(
      height: screenHeight*0.74,
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
                                      i++;
                                  return generalNotificationItem(
                                      notification.value, i /*notification.key*/);
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
                    "No Notifications",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
              child: ShimmerList(itemCount: 2),
            ),
    );
  }

  Widget _buildSearch(){
    return Container(
      height: 43,
      width: screenWidth,
      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[100],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        style: TextStyle(
          fontSize: 14.0,
        ),
        obscureText: false,
        obscuringCharacter: "*",
        controller: _searchController,
        onChanged: (value) {
          //_isValidInput();
        },
        onSubmitted: (value) {},
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search",
          icon: Icon(Icons.search),
        ),
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
    return Center(
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: index % 2 == 0
              ? Colors.white
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
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text("${data.detail}",
                      style: TextStyle(fontSize: 11, color: Colors.black54)),
                  Text(
                    "${data.date}",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios_sharp,size: 15,)
            ],
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
