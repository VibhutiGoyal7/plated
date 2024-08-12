import 'package:Payrio/languageSection/Languages.dart';
import 'package:Payrio/model/db/dao.dart';
import 'package:Payrio/model/request/notificationListRequest.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/db/PayorioDatabase.dart';
import '../../../model/response/notificationListResponse.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/ShimmerList.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var imageUrl;
  late double screenWidth;
  late double screenHeight;
  late PayorioDatabase database;
  late NotificationDao notificationDao;
  List<NotificationDetail> generalNotificationList = [];
  List<NotificationDetail> transactionalNotificationList = [];

  final _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  final _numberOfPostsPerRequest = 20;
  Future<void>? _fetchDataFuture;
  static const maxDuration = Duration(seconds: 2);
  late PageController _pageController;
  int _currentIndex = 0;
  // late TabController _tabController;
  int _currentTabIndex = 0;

  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  bool isInternetConnected = true;
  String generalType = "general";
  String transactionType = "transaction";
  String selectedNotificationType = "";


  void initState() {
    super.initState();
    imageUrl = "";
    intializeDatabase();
    _scrollController.addListener(_generalLoadMore);
    selectedNotificationType = generalType;

    _fetchDataFuture = _fetchData(_currentPage, false);
  }

  runApi(int? index){
    if(index == 0){
      setState(() {
        selectedNotificationType =generalType;
      });
      _currentPage = 1;
      _scrollController.addListener(_generalLoadMore);
      //_fetchData(_currentPage, true);
      _fetchDataFuture = _fetchData(_currentPage, false);
      _fetchPaginatedNotifications(selectedNotificationType, _currentPage);
   //
    }
    else{
      setState(() {
        selectedNotificationType = transactionType;
      });
      _currentPage = 1;
      _scrollController.addListener(_transactionalLoadMore);
      _fetchDataFuture = _fetchData(_currentPage, false);
      _fetchPaginatedNotifications(selectedNotificationType, _currentPage);
     // _fetchDataFuture = _fetchData(_currentPage, false);

    }
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
  void _transactionalLoadMore() async {
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

  Future<void> _fetchData(int pageKey, bool isScroll) async
  {
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
              content: Text('${Languages.of(context)?.labelNoInternetConnection}'),
              duration: maxDuration,
            ),
          );
        });
      } else {
        SortingDetail sorting = SortingDetail(createdAt: "desc");
        NotificationListRequest request = NotificationListRequest(
          pageNo: pageKey,
          pageSize: _numberOfPostsPerRequest,
          notificationType: selectedNotificationType,
          sorting: sorting,
        );
        await Provider.of<MainViewModel>(context, listen: false)
            .notificationListData("api/v1/app/notifications/list", request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await getNotificationData(context, apiResponse, pageKey, isScroll);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }


  Future<void> getNotificationData(BuildContext context, ApiResponse apiResponse,
      int pageKey, bool isScroll) async
  {
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
        // Insert into the local database

        await database.notificationDao.insertNotifications(newItems);

        await _fetchPaginatedNotifications(selectedNotificationType, pageKey);
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

  Future<void> _fetchPaginatedNotifications(String type, int pageKey) async
  {
    final notifications = await database.notificationDao
        .fetchNotifications(type, _numberOfPostsPerRequest, (pageKey - 1) * _numberOfPostsPerRequest);

    setState(() {
      if (type == generalType) {
        if (pageKey == 1) {
          generalNotificationList.clear();
        }
        generalNotificationList.addAll(notifications);
      } else if (type == transactionType) {
        if (pageKey == 1) {
          transactionalNotificationList.clear();
        }
        transactionalNotificationList.addAll(notifications);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(Languages.of(context)!.labelNotification),
        ),
        body:
        Column(
          children: [
            TabBar(
                dividerHeight: 0.5,
                labelColor: AppColor.WHITE,
                unselectedLabelColor: AppColor.PRIMARY,
                indicatorPadding: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                labelPadding: EdgeInsets.zero,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicator: BoxDecoration(
                  color: AppColor.PRIMARY,
                ),
                onTap: (index) {
                  runApi(index);
              },
              dividerColor: Colors.transparent,
              tabs: [
                  Container(
                    width: screenWidth * 0.5,
                    child: Tab(text: "${Languages.of(context)!.labelGeneral}"),
                  ),
                  Container(
                    width: screenWidth * 0.5,
                    child: Tab(
                        text: "${Languages.of(context)!.labelTransactional}"),
                  ),
                ],
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [generalNotification(), transactionalNotification()],


              ),

            ),
          ],
        )


      ),
    );
  }
  Widget generalNotification(){

    return  Container(
      margin: EdgeInsets.only(top: 12),
      child: isInternetConnected && !isLoading
          ? checkListEmpty(generalNotificationList)
          ? FutureBuilder(
        future: _fetchDataFuture,
        builder: (BuildContext context,
            AsyncSnapshot<void> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child:
                Text('Error loading data'));
          } else {
            // Group transactions by date
            Map<String,
                List<NotificationDetail>>
            groupedNotifications =
            groupNotificationsByDate(
               generalNotificationList);
            List<String> dates =
            groupedNotifications.keys
                .toList();

            return ListView.builder(
              controller: _scrollController,
              itemCount: dates.length +
                  (_isLoadingMore ? 1 : 0),
              itemBuilder:
                  (BuildContext context,
                  int index) {
                if (index == dates.length) {
                  return Center(
                      child:
                      CircularProgressIndicator());
                }
                String date = dates[index];
                List<NotificationDetail>
                notificationsForDate =
                groupedNotifications[date]!;

                return Padding(
                  padding:
                  const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets
                            .all(8.0),
                        child: Text(
                          date,
                          style: TextStyle(
                              fontWeight:
                              FontWeight
                                  .w600,
                              fontSize: 12),
                        ),
                      ),
                      ...notificationsForDate
                          .map((notification) {
                        return generalNotificationItem(notification);
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
          style: TextStyle(
              fontSize: 15, color: Colors.grey),
        ),
      )
          : Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 8, vertical: 18),
        child: ShimmerList(itemCount: 2),
      ),
    );
  }
  Map<String, List<NotificationDetail>> groupNotificationsByDate(
      List<NotificationDetail> notifications) {
    Map<String, List<NotificationDetail>> groupedNotifications = {};

    for (var notification in notifications) {
      String date = convertDateFormat("${notification.createdAt}");
      if (!groupedNotifications.containsKey(date)) {
        groupedNotifications[date] = [];
      }
      groupedNotifications[date]!.add(notification);
    }
    return groupedNotifications;
  }


  Widget generalNotificationItem(NotificationDetail data) {
    return Center(
      child: Container(
        width: screenWidth*0.88,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.PRIMARY,width: 0.22),
          borderRadius: BorderRadius.circular(12)
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*imageUrl == "" || imageUrl == null
                  ? Center(
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade700,
                        highlightColor: Colors.grey,
                        child: Container(
                          height: screenHeight*0.19,
                          width: screenWidth*0.8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                            border: Border.all(width: 0.12, color: Colors.grey),
                            borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                      ),
                  )
                  : Center(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: AppColor.PRIMARY, width: 0.3),
                          color: Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            imageUrl,
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                              return Shimmer.fromColors(
                                baseColor: Colors.white38,
                                highlightColor: Colors.grey,
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.white,
                                ),
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: Colors.white38,
                                  highlightColor: Colors.grey,
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                  ),*/
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                child: Text("${data.title}", ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                child: Text("${data.message}",style: TextStyle(fontSize: 12)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(convertDateTimeFormat("${data.createdAt}"),style: TextStyle(fontSize: 11), ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  bool checkListEmpty(List<NotificationDetail> list) {
    bool isListEmpty = false;

      isListEmpty= list.isNotEmpty;

    return  isListEmpty;
  }


  Widget transactionalNotificationItem(NotificationDetail data) {
    return Center(
      child: Container(
        width: screenWidth*0.88,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.PRIMARY,width: 0.2),
            borderRadius: BorderRadius.circular(12)
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                child: Text("${data.title}",style: TextStyle(fontWeight: FontWeight.bold) ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                child: Text("${data.message}",style: TextStyle(fontSize: 12)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 1),
                child: Text(convertDateTimeFormat("${data.createdAt}"),style: TextStyle(fontSize: 11), ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget transactionalNotification(){
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: isInternetConnected && !isLoading
          ? checkListEmpty(transactionalNotificationList)
          ? FutureBuilder(
        future: _fetchDataFuture,
        builder: (BuildContext context,
            AsyncSnapshot<void> snapshot) {
         if (snapshot.hasError) {
            return Center(
                child:
                Text('Error loading data'));
          } else {
            // Group transactions by date
            Map<String,
                List<NotificationDetail>>
            groupedNotifications =
            groupNotificationsByDate(
                transactionalNotificationList);
            List<String> dates =
            groupedNotifications.keys
                .toList();

            return ListView.builder(
              controller: _scrollController,
              itemCount: dates.length +
                  (_isLoadingMore ? 1 : 0),
              itemBuilder:
                  (BuildContext context,
                  int index) {
                if (index == dates.length) {
                  return Center(
                      child:
                      CircularProgressIndicator());
                }
                String date = dates[index];
                List<NotificationDetail>
                notificationsForDate =
                groupedNotifications[date]!;

                return Padding(
                  padding:
                  const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets
                            .all(8.0),
                        child: Text(
                          date,
                          style: TextStyle(
                              fontWeight:
                              FontWeight
                                  .w600,
                              fontSize: 12),
                        ),
                      ),
                      ...notificationsForDate
                          .map((notification) {
                        return transactionalNotificationItem(notification);
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
          style: TextStyle(
              fontSize: 15, color: Colors.grey),
        ),
      )
          : Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 8, vertical: 18),
        child: ShimmerList(itemCount: 2),
      ),
    );
  }

  Future<void> intializeDatabase() async {
    database = await $FloorPayorioDatabase
        .databaseBuilder('payorio_database.db')
        .build();

    notificationDao = database.notificationDao;
    _fetchPaginatedNotifications(selectedNotificationType, _currentPage);
  }

}



class NotificationItem extends StatelessWidget {
  final NotificationData data;

  NotificationItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, "/NotificationDetailScreen");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.notificationHeading != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      data.notificationHeading!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                SizedBox(height: 5),
                if (data.notificationContent != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      data.notificationContent!,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class NotificationData {
  final String? notificationHeading;
  final String? notificationContent;
  final String? notificationDate;

  NotificationData({this.notificationHeading, this.notificationContent, this.notificationDate});
}

