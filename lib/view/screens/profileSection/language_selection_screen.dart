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
  var mLanguages = [
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
          mLanguages.map((Language items) {
            if (selectedLanguageValue == items.code) {
              isLoading = false;
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
          onPressed: () => {
            Navigator.pushReplacementNamed(context, "/SettingScreen")
          },

        ),
        title: Text(Languages.of(context)!.labelLanguage),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
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
                          itemCount: mLanguages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {

                                await Helper.setLocale(mLanguages[index].code);
                                setState(() {
                                  isLoading = false;
                                  selectedLanguageName = mLanguages[index].name;
                                  if (mounted) {
                                    selectedLanguageValue = mLanguages[index].code!;
                                  }
                                  widget.setLocale(Locale(mLanguages[index].code, ''));
                                  print(selectedLanguageValue);
                                });
                              },
                              child: LanguageItem(data: mLanguages[index], selectedLanguageCode: selectedLanguageValue,),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isLoading ? Stack(
              children: [
                // Block interaction
                ModalBarrier(
                    dismissible: false,
                    color: Colors.transparent),
                // Loader indicator
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ): SizedBox()
          ],
        ),
      )

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
