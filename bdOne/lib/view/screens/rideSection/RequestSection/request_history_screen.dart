import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../languageSection/Languages.dart';
import '../../../../../model/apis/api_response.dart';
import '../../../../../utils/Util.dart';
import '../../../../../view_model/main_view_model.dart';
import '../../../../model/request/requestHistoryListRequest.dart';
import '../../../../model/response/requestListResponse.dart';
import '../../../../theme/AppColor.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/custom_circular_progress.dart';
import '../../../component/custom_text_component.dart';
import '../../../component/session_expired_dialog.dart';
import '../../../component/text_component.dart';

class RequestHistoryScreen extends StatefulWidget {
  @override
  _RequestHistoryScreenState createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> {
  String status = "";
  String requestType = "";
  bool expanded = false;
  bool inputValid = false;
  bool filterApplied = false;
  List<RequestDetails> requestList = [];
  List<RequestDetails> filteredRequestList = [];
  final tokenInputController = TextEditingController();
  var screenHeight;
  var screenWidth;
  late bool isDarkMode;
  bool isTablet = false;
  String selectedStartTime = "Start Date";
  String selectedEndTime = "End Date";

  //Time
  TimeOfDay timeOfDay = TimeOfDay.now();
  ScrollController _firstTabController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  Future<void>? _fetchDataFuture;
  static const maxDuration = Duration(seconds: 2);
  String selectedValue = "All";
  bool isLoading = false;
  bool isInternetConnected = true;
  final TextEditingController _paymentStartDateController =
      TextEditingController(text: "00:00");
  final TextEditingController _paymentEndController =
      TextEditingController(text: "00:00");

  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    inputValid = false;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness:
          Brightness.light, // Light icons for the status bar
      //statusBarBrightness: Brightness.light,       // Status bar brightness (for iOS)
    ));
    _firstTabController.addListener(_generalLoadMore);
    _fetchDataFuture = _fetchData(_currentPage, filterApplied, false);
  }

  @override
  void dispose() {
    tokenInputController.dispose();
    _firstTabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData(
    int pageKey,
    bool filterApplied,
    bool isScroll,
  ) async {
    try {
      setState(() {
        isLoading = true;
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
        RequestHistoryListRequest request = RequestHistoryListRequest(
            status: "completed", pageNo: pageKey, pageSize: 10);
        await Provider.of<MainViewModel>(context, listen: false)
            .getRequestHistoryListData("",request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await getRequestData(context, apiResponse, isScroll);
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<Widget> getRequestData(
      BuildContext context, ApiResponse apiResponse, bool isScroll) async {
    RequestListResponse? requestListResponse =
        apiResponse.data as RequestListResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CustomCircularProgress());
      case Status.COMPLETED:
        if (isScroll) {
          requestList.addAll(requestListResponse?.data ?? []);
        } else {
          requestList = requestListResponse?.data ?? [];
        }
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        }
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

  Map<String, List<RequestDetails>> groupRequestsByDate(
      List<RequestDetails> requests) {
    Map<String, List<RequestDetails>> groupedRequests = {};

    for (var request in requests) {
      String date = convertDateFormat("${request.createdAt}");
      if (!groupedRequests.containsKey(date)) {
        groupedRequests[date] = [];
      }
      groupedRequests[date]!.add(request);
    }
    return groupedRequests;
  }

  void _generalLoadMore() async {
    if (!_isLoadingMore &&
        _firstTabController.position.pixels ==
            _firstTabController.position.maxScrollExtent) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
      await _fetchData(_currentPage, filterApplied, true);
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    isTablet = getIsTablet(context, screenWidth, screenHeight);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        if (kDebugMode) {
          Navigator.pushReplacementNamed(
            context,
            "/BottomNav",
            arguments: 0,
          );
          // return Future.value(true);
        }
        Navigator.pushReplacementNamed(
          context,
          "/BottomNav",
          arguments: 0,
        );
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (Platform.isIOS) {
            if (details.velocity.pixelsPerSecond.dx > 50) {
              if (isKeyboardOpen(context)) {
                hideKeyBoard();
              } else {
                Navigator.pushNamed(context, "/BottomNav", arguments: 0);
              }
            }
          }
        },
        onTap: () => {hideKeyBoard()},
        child: Scaffold(
         // backgroundColor: Theme.of(context).colorScheme.surface,
          body: Stack(
            children: [
              FutureBuilder(
                future: _fetchDataFuture,
                builder: (context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: TextComponent(
                            text: "Error loading data",
                            fontSize: 14,
                            isBold: false));
                  }

                  Map<String, List<RequestDetails>> groupedRequests =
                      groupRequestsByDate(requestList);
                  List<String> dates = groupedRequests.keys.toList();
                  int i = 0;

                  return CustomScrollView(
                    controller: _firstTabController,
                    slivers: [
                      CupertinoSliverNavigationBar(
                        largeTitle: Text(
                          "HISTORY",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                             color:isDarkMode ? AppColor.WHITE :AppColor.BLACK
                          ),
                        ),
                        middle: CustomTextComponent(
                            text: "HISTORY",
                            fontSize: 22,
                            fontColor: isDarkMode ? AppColor.WHITE :AppColor.BLACK,
                            isBold: false),
                        backgroundColor:isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.WHITE,
                        alwaysShowMiddle: false,
                        leading: SizedBox(),
                        border: Border.all(color: Colors.transparent),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            String date = dates[index];
                            List<RequestDetails> requestForDate =
                                groupedRequests[date]!;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextComponent(
                                          text: date,
                                          fontSize: 11,
                                          isBold: true)),
                                  ...requestForDate
                                      .asMap()
                                      .entries
                                      .map((request) {
                                    i++;
                                    return RequestItem(
                                      request: request.value,
                                      index: i,
                                    );
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
              isLoading
                  ? Stack(
                      children: [
                        // Block interaction
                        ModalBarrier(
                          dismissible: false,
                        ),
                        // Loader indicator
                        /* Center(
                            child: CircularProgressIndicator(color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY_BLUE,),
                          ),*/
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void _showModal(BuildContext context, ApiResponse apiResponse) {
    showModalBottomSheet(
      shape: ContinuousRectangleBorder(),
      isScrollControlled: false,
      // Ensure the sheet takes full height
      constraints: BoxConstraints(maxWidth: screenWidth, minWidth: screenWidth),
      context: context,
      sheetAnimationStyle: AnimationStyle(
          curve: FlippedCurve(Curves.bounceInOut),
          duration: Duration(milliseconds: 300),
          reverseDuration: Duration(milliseconds: 300)),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextComponent(
                          text: "${Languages.of(context)?.labelFilterPayment}",
                          fontSize: 20,
                          isBold: false),
                      IconButton(
                        icon: Icon(Icons.cancel_outlined),
                        color: isDarkMode
                            ? Colors.white
                            : Theme.of(context).cardColor,
                        style:
                            ButtonStyle(iconSize: WidgetStateProperty.all(30)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Wrap(spacing: 15, runSpacing: 15, children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStartDateInput(
                            context,
                            "Start Date",
                            _paymentStartDateController,
                            Icon(
                              Icons.access_time,
                              size: 20,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            setState),
                        _buildEndDateInput(
                            context,
                            "End Date",
                            _paymentEndController,
                            Icon(
                              Icons.access_time,
                              size: 20,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            setState),
                      ],
                    ),
                  ]),
                  TextComponent(
                      text: "${Languages.of(context)?.labelStatus}",
                      fontSize: 16,
                      isBold: false),
                  Row(
                    children: [
                      filterStatusCard(
                          "${Languages.of(context)?.labelSuccess}", setState),
                      filterStatusCard(
                          "${Languages.of(context)?.labelPending}", setState),
                      filterStatusCard(
                          "${Languages.of(context)?.labelRejected}", setState),
                      filterStatusCard(
                          "Failed", setState),
                    ],
                  ),
/*                  isTransactional
                      ? SizedBox()
                      : Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            Text(
                              "${Languages.of(context)?.labelRequestType}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: [
                                filterRequestTypeCard(
                                    "${Languages.of(context)?.labelDeposit}",
                                    setState),
                                filterRequestTypeCard(
                                    "${Languages.of(context)?.labelWithdraw}",
                                    setState),
                              ],
                            ),
                          ],
                        ),*/
                  _buildFooter(context, apiResponse),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget filterStatusCard(String text, StateSetter setState) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth / 4) - 18;
    return GestureDetector(
      onTap: () {
        setState(() {
          status = text;
        });
      },
      child: IntrinsicWidth(
        child: Card(
          color: status == text
              ? Theme.of(context).cardColor
              : isDarkMode
                  ? AppColor.DARK_CARD_COLOR
                  : AppColor.WHITE,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 0.1,
                  color: status == text
                      ? Theme.of(context).cardColor
                      : isDarkMode
                          ? AppColor.WHITE
                          : AppColor.DARK_CARD_COLOR),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Container(
            width: cardWidth,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: status == text
                    ? AppColor.WHITE
                    : isDarkMode
                        ? AppColor.WHITE
                        : AppColor.DARK_CARD_COLOR,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget filterRequestTypeCard(String text, StateSetter setState) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth / 4) - 80;
    return GestureDetector(
      onTap: () {
        setState(() {
          requestType = text;
        });
      },
      child: Card(
        color: requestType == text
            ? Theme.of(context).cardColor
            : isDarkMode
                ? AppColor.DARK_CARD_COLOR
                : AppColor.WHITE,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 0.1,
                color: requestType == text
                    ? Theme.of(context).cardColor
                    : isDarkMode
                        ? AppColor.WHITE
                        : AppColor.DARK_CARD_COLOR),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
            width: cardWidth,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: CustomTextComponent(
                text: text,
                fontSize: 14,
                fontColor: requestType == text
                    ? AppColor.WHITE
                    : isDarkMode
                        ? AppColor.WHITE
                        : AppColor.DARK_CARD_COLOR,
                isBold: false)),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ApiResponse apiResponse) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth / 2) - 62;
    double cardApplyWidth = (screenWidth / 2) - 10;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: cardWidth,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: CustomTextComponent(
                      text: "${Languages.of(context)?.labelClearAll}",
                      fontSize: 14,
                      fontColor: Theme.of(context).cardColor,
                      isBold: false),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      backgroundColor: AppColor.WHITE,
                      elevation: 3,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(2))),
                ),
              ),
            ),
            Container(
              width: cardApplyWidth,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: CustomTextComponent(
                      text: "${Languages.of(context)?.labelApply}",
                      fontSize: 14,
                      fontColor: Colors.white,
                      isBold: false),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      backgroundColor: Theme.of(context).cardColor,
                      elevation: 3,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(2))),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStartDateInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon, StateSetter setState) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth / 2) - 28;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextComponent(text: text, fontSize: 16, isBold: false),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          child: Card(
            color: status == text
                ? Theme.of(context).cardColor
                : isDarkMode
                    ? AppColor.DARK_CARD_COLOR
                    : AppColor.WHITE,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 0.1,
                    color: status == text
                        ? Theme.of(context).cardColor
                        : isDarkMode
                            ? AppColor.WHITE
                            : AppColor.DARK_CARD_COLOR),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Container(
              height: 40,
              width: cardWidth,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    hideKeyBoard();
                    _selectDateTime(context, text, setState, "");
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color:
                              isDarkMode ? AppColor.WHITE : AppColor.TEXT_COLOR,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomTextComponent(
                            text: selectedStartTime,
                            fontSize: 14,
                            fontColor: selectedStartTime == text
                                ? Colors.grey
                                : AppColor.TEXT_COLOR,
                            isBold: false)
                      ],
                    ),
                    /*GestureDetector(

                        child: Icon(Icons.timer_outlined)),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEndDateInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon, StateSetter setState) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth / 2) - 28;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextComponent(text: text, fontSize: 16, isBold: false),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          child: Card(
            color: status == text
                ? Theme.of(context).cardColor
                : isDarkMode
                    ? AppColor.DARK_CARD_COLOR
                    : AppColor.WHITE,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 0.1,
                    color: status == text
                        ? Theme.of(context).cardColor
                        : isDarkMode
                            ? AppColor.WHITE
                            : AppColor.DARK_CARD_COLOR),
                borderRadius: BorderRadius.all(Radius.circular(6))),
            child: Container(
              height: 40,
              width: cardWidth,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    hideKeyBoard();
                    if (selectedStartTime != "Start Date") {
                      _selectDateTime(
                          context, text, setState, selectedStartTime);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color:
                              isDarkMode ? AppColor.WHITE : AppColor.TEXT_COLOR,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomTextComponent(
                            text: selectedEndTime,
                            fontSize: 14,
                            fontColor: selectedEndTime == text
                                ? Colors.grey
                                : AppColor.TEXT_COLOR,
                            isBold: false)
                      ],
                    ),
                    /*GestureDetector(

                        child: Icon(Icons.timer_outlined)),*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool checkListEmpty() {
    bool isListEmpty = false;
    if (!filterApplied) {
      isListEmpty = requestList.isNotEmpty;
    } else {
      isListEmpty = filteredRequestList.isNotEmpty;
    }
    return isListEmpty;
  }

  Future<void> _selectDateTime(BuildContext context, String date,
      StateSetter setState, String startDate) async {
    DateTime start = DateTime(1960);
    if (startDate != "") {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      start = dateFormat.parse(startDate);
    }
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: start,
      // DateTime.now() - not to allow to choose before today.
      lastDate: DateTime.now(),
      helpText: "${Languages.of(context)?.labelSelectDob}",
      confirmText: "${Languages.of(context)?.labelConfirm}",
      errorFormatText: '${Languages.of(context)?.labelEnterValidDate}',
      errorInvalidText: '${Languages.of(context)?.labelEnterDateInValidRange}',
      builder: (context, child) {
        return Theme(
          data: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        final formattedDate = convertDateFormat(
            "${DateTime(selectedDate.year, selectedDate.month, selectedDate.day)}");

        if (date == "Start Date") {
          //if (selectedEndTime.isEmpty || selectedDate.isBefore(DateTime.parse(selectedEndTime))) {
          _paymentStartDateController.text = formattedDate;
          selectedStartTime = formattedDate;
          _paymentEndController.text = "00:00";
          selectedEndTime = "End Date";
          // } else {
          // Show error: Start date must be before end date.
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Start date must be before end date."),));
          // }
        } else {
          //if (selectedStartTime.isEmpty || selectedDate.isAfter(DateTime.parse(selectedStartTime))) {
          _paymentEndController.text = formattedDate;
          selectedEndTime = formattedDate;
          //} else {
          // Show error: End date must be after start date.
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("End date must be after start date."),));
          //}
        }
      });
    }
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _paymentStartDateController.text =
            "${time.hour}:${time.minute} ${time.period.name}";
        selectedStartTime = "${time.hour}:${time.minute} ${time.period.name}";
      });
    }
  }
}

class RequestItem extends StatelessWidget {
  final RequestDetails request;
  final int? index;
  late final bool isTablet;
  late final double screenHeight;
  late final double screenWidth;

  RequestItem({required this.request, required this.index});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    isTablet = getIsTablet(context, screenWidth, screenHeight);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/RequestOverviewScreen",
            arguments: request);
      },
      child: Card(
        elevation: 1,
        /*index! % 2 == 0
            ? isDarkMode ? AppColor.DARK_BG_COLOR : AppColor.BG_COLOR
            : Theme.of(context).dividerColor,*/
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextComponent(
                            text:
                                capitalizeFirstLetter("${request.serviceType}"),
                            fontSize: 16,
                            isBold: true),
                        CustomTextComponent(
                          text: capitalizeFirstLetter("${request.status}"),
                          fontSize: 12,
                          isBold: false,
                          fontColor: AppColor.PRIMARY_GREEN,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: screenWidth * 0.68,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.4)),
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                        size: 12,
                                      )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                      child: Text(
                                    "${request.pickupAddress}",
                                    style: TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ))
                                ],
                              ),
                              Container(
                                height: 16,
                                width: 0.3,
                                margin: EdgeInsets.only(left: 10),
                                color: Colors.grey,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.4)),
                                      padding: EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.my_location,
                                        color: Colors.green,
                                        size: 12,
                                      )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                      child: Text(
                                    "${request.dropAddress}",
                                    style: TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            request.distance != null
                                ? TextComponent(
                                    text: "${request.distance ?? ""}",
                                    fontSize: 12,
                                    isBold: true)
                                : SizedBox(),
                            TextComponent(
                                text: "৳${request.fare ?? 0}",
                                fontSize: 20,
                                isBold: true),
                            SizedBox(
                              height: 6,
                            ),
                            TextComponent(
                                text: "${convertTime("${request.createdAt}")}",
                                fontSize: 10,
                                isBold: false)
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              /* Container(
                height: 0.1,
                width: screenWidth,
                color: isDarkMode ? AppColor.WHITE : Colors.black,
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 8),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
