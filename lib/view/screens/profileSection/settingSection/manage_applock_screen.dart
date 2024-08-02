import 'package:flutter/material.dart';
import 'package:Payrio/theme/AppColor.dart';

import '../../../../languageSection/Languages.dart';

class ManageAppLockScreen extends StatefulWidget {
  @override
  _ManageAppLockScreenState createState() => _ManageAppLockScreenState();
}

class _ManageAppLockScreenState extends State<ManageAppLockScreen> {
  String token = "";
  late double screenWidth;
  late double screenHeight;
  late bool isDarkMode;

  bool screenLockSelected = true;
  bool pinSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Enable app lock",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 12,),

            GestureDetector(
              onTap: (){
                setState(() {
                  screenLockSelected = true;
                  pinSelected = false;
                });
              },
              child:  _buildCard("Use your screen lock", "Use your existing PIN, pattern, face Id or fingerprint", "Works offline", Icons.pin, Icons.signal_wifi_connected_no_internet_4, screenLockSelected),
            ),

            GestureDetector(
              onTap: (){
                setState(() {
                  pinSelected = true;
                  screenLockSelected = false;
                });
              },
              child:  _buildCard("Use 4-digit Payorio PIN", "Create a Payorio PIN so only you can pay with your phone", "Needs internet connection", Icons.people, Icons.cell_tower_rounded, pinSelected),
            ),
            SizedBox(height: 12,),
            
            Row(
              children: [
                Icon(Icons.info_outline_rounded),
                SizedBox(width: 5,),
                Text("Learn more"),
                Spacer(),
                Icon(Icons.arrow_forward_ios, size: 18,)
              ],
            ),


            Spacer(),

            _buildFooter(context)
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String heading, String subHeading1, String subHeading2, IconData icon1, IconData icon2, bool isSelected){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side:isSelected? BorderSide(width: 1.2, color:  AppColor.PRIMARY)
              :
            BorderSide(width: 0.5, color: isDarkMode?AppColor.WHITE: Colors.black)),
        child: GestureDetector(
          onTap: (){

          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(heading, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                    SizedBox(width: 5,),
                    isSelected ?
                    Icon(Icons.check_circle) :
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border(top: BorderSide(color: AppColor.PRIMARY,width: 0.8), bottom:  BorderSide(color: AppColor.PRIMARY,width: 0.8),
                            left:  BorderSide(color: AppColor.PRIMARY,width: 0.8), right:  BorderSide(color: AppColor.PRIMARY,width: 0.8))
                          ),
                        )
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  width: screenWidth*0.7,
                  child: Row(
                    children: [
                      Icon(icon1, size: 20,),
                      SizedBox(width: 8,),
                      Expanded(
                        child: Text(subHeading1, style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.visible, maxLines: null,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4,),
                Row(

                  children: [
                    Icon(icon2, size: 20,),
                    SizedBox(width: 8,),
                    Expanded(
                      child: Text(subHeading2, style: TextStyle(fontSize: 12, ),
                        overflow: TextOverflow.visible, maxLines: null,),
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

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                //Navigator.pushReplacementNamed(context, '/MoneySafeScreen');
              },
              child: Text(
                "Done",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: AppColor.PRIMARY,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
          ),
        ],
      ),
    );
  }
}
