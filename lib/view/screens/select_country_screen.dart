import 'package:flutter/material.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({Key? key}) : super(key: key);
  @override
  _SelectCountryScreenState createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  List<String> _allLogList = [
    "India",
    "India",
    "India",
    "India",
    "SriLanka",
    "Bangladesh",
    "Nepal",
    "Pakistan",
    "Bhutan",
  ];
  List<String> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _filteredList = List.from(_allLogList);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _filterLogListBySearchText(String searchText) {
    setState(() {
      _filteredList = _allLogList
          .where((logObj) =>
              logObj.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("ISSUING COUNTRY",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text("Suggested Country", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            Container(
              //height: 40,
              decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.search_rounded,
                    ),
                    onPressed: () => FocusScope.of(context).unfocus(),
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                      ),
                      onPressed: () {
                        _textController.text = "";
                        _filterLogListBySearchText("");
                      }),
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (value) => _filterLogListBySearchText(value),
                onSubmitted: (value) => _filterLogListBySearchText(value),
              ),
            ),
            Expanded(
              //height: screenSize.height/2,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: _filteredList.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 10),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_filteredList[index])
                  );
                  // I omit the part to build card items from the list
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
