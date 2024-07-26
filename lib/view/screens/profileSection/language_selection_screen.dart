import 'package:Payrio/view/screens/profileSection/setting_screen.dart';
import 'package:flutter/material.dart';

import '../../../languageSection/Languages.dart';
import '../../../utils/Helper.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  var screenHeight;
  var screenWidth;
  late bool isDarkMode;
  String selectedLanguageValue = "";
  String selectedLanguageName = "";
  var mCities = [
    Language("English", "en"),
    Language("Arabic", "ar"),
    Language("Hindi", "hi")
  ];

  bool isLoading = true;
  bool isInternetConnected = true;

  @override
  void initState() {
    super.initState();

    Helper.getLocale().then((selectedLanguage) {
      print(selectedLanguage.languageCode);

      // Ensure that setState is called synchronously after the async work is done
      if (mounted) {
        setState(() {
          selectedLanguageValue = selectedLanguage.languageCode;
          mCities.map((Language items) {
            if (selectedLanguageValue == items.code) {
              selectedLanguageName = items.name;
            }
          }).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(Languages.of(context)!.labelNotification),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          /*  Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: screenWidth,
              child: Text(
                selectedLanguageName,
              ),
            ),*/
            Expanded(
              child: Card(
                elevation: 4,
                child: Container(
                  child: ListView.builder(
                    itemCount: mCities.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedLanguageName = mCities[index].name;
                          });
                        },
                        child: LanguageItem(data: mCities[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageItem extends StatelessWidget {
  final Language data;
  var screenWidth;

  LanguageItem({required this.data});

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.name != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                child: Text(
                  data.name!,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(bottom: 3),
                width: screenWidth * 0.8,
                height: 0.3,
                decoration: BoxDecoration(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
