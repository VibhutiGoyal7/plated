import 'package:flutter/material.dart';

import '../../../languageSection/Languages.dart';
class ChooseDocScreen extends StatefulWidget {
  @override
  _ChooseDocScreenState createState() => _ChooseDocScreenState();
}

class _ChooseDocScreenState extends State<ChooseDocScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
        "Choose Your Document",
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: Text(
                  'ISSUING COUNTRY',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'India',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: Text(
                  'ACCEPTED DOCUMENTS',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              _buildDocumentOption(
                context,
                'Passport',
                'Photo page',
                '/CameraAccessScreen',
                'passport',
                "assets/passport.png"
              ),
              _buildDocumentOption(
                context,
                'Driving License',
                'Front and Back',
                '/CameraAccessScreen',
                'national_id',
                "assets/license.png"
              ),
              _buildDocumentOption(
                context,
                'National Identity Card',
                'Front and Back',
                '/CameraAccessScreen',
                'driving_licence',
                "assets/id_card.png"
              ),
              _buildDocumentOption(
                context,
                'Video Verification',
                'Front ',
                '/VideoKycScreen',
                'video',
                "assets/video.png"
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentOption(BuildContext context, String title, String subtitle, String route, String data, String icon) {
    return GestureDetector(
      onTap: () => Navigator?.pushNamed(context,route, arguments: "${data}"),
      child: Container(
        width: double.infinity,
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Image(
                  alignment: Alignment.topLeft,
                  width: 25,
                  image: AssetImage(icon),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 6),
                child: Text(
                  "Pending",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
