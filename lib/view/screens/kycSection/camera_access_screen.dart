import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraAccessScreen extends StatefulWidget {

  final String? data; // Define the 'data' parameter here

  CameraAccessScreen({Key? key, this.data}) : super(key: key);
  @override
  _CameraAccessScreenState createState() => _CameraAccessScreenState();
}

class _CameraAccessScreenState extends State<CameraAccessScreen> {
  String docType = '';
  @override
  void initState() {
    super.initState();
    docType = widget.data.toString();
  }

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
            "Verify your Identity",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
            Text("Allow Camera Access", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("When prompted, you must enable camera access to continue", style: TextStyle(fontSize: 18),),
            SizedBox(height: 50,),
            Row(
              crossAxisAlignment:CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.camera_enhance_sharp, size: 170,),
            ],),
            Spacer(),
            _buildFooter(context)
          ]),
        ));
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
                if (await checkPermissionStatus()) {
                  Navigator.pushNamed(context, "/DocImageScreen", arguments: "${docType}");
                } else {
                  requestPermission();
                }
              },
              child: Text(
                "Enable Camera",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: Colors.blueAccent,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkPermissionStatus() async {
    final permission = Permission.camera;

    return await permission.status.isGranted;
  }

  Future<void> requestPermission() async {
    final permission = Permission.camera;

    if (await permission.isDenied) {
      await permission.request();
    } else if(await permission.isGranted) {
      Navigator.pushNamed(context, "/DocImageScreen");
    }
  }
}
