import 'package:Payrio/theme/AppColor.dart';
import 'package:Payrio/view/screens/profileSection/setting_screen.dart';
import 'package:flutter/material.dart';

import '../../../languageSection/Languages.dart';
import '../../../utils/Helper.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  LanguageSelectionScreen({required this.setLocale});
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
        title: Text(Languages.of(context)!.labelLanguage),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                          setState(() async {
                            selectedLanguageName = mCities[index].name;
                            await Helper.setLocale(mCities[index].code);
                            if (mounted) {
                              setState(() {
                                selectedLanguageValue = mCities[index].code!;
                              });
                            }
                            widget.setLocale(Locale(mCities[index].code, ''));
                            print(selectedLanguageValue);
                          });
                        },
                        child: LanguageItem(data: mCities[index], selectedLanguageCode: selectedLanguageValue,),
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
  final String selectedLanguageCode;
  var screenWidth;

  LanguageItem({required this.data,required this.selectedLanguageCode});

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: selectedLanguageCode == data.code? AppColor.PRIMARY : AppColor.WHITE
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.name != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 14.0),
                child: Text(
                  data.name!,
                  style: TextStyle(fontSize: 16,
                      color: selectedLanguageCode == data.code? AppColor.WHITE : AppColor.BLACK),
                ),
              ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(bottom: 0),
                width: screenWidth * 0.85,
                height: 0.3,
                decoration: BoxDecoration(color: selectedLanguageCode == data.code? AppColor.WHITE : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
