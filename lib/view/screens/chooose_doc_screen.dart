import 'package:flutter/material.dart';
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  'Choose Your Document',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  'Select issuing country to see which documents we accept',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: Text(
                  'ISSUING COUNTRY',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () { Navigator?.pushNamed(context,"/");},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
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
                      Icon(
                        Icons.arrow_forward_ios,
                      ),
                    ],
                  ),
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
                '/clickImagePermissionScreen/passport',
              ),
              _buildDocumentOption(
                context,
                'Driving License',
                'Front and Back',
                '/clickImagePermissionScreen/driving_licence',
              ),
              _buildDocumentOption(
                context,
                'National Identity Card',
                'Front and Back',
                '/clickImagePermissionScreen/national_id',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentOption(BuildContext context, String title, String subtitle, String route) {
    return GestureDetector(
      onTap: () => Navigator?.pushNamed(context,route),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(
              Icons.arrow_forward_ios,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
          ],
        ),
      ),
    );
  }
}
