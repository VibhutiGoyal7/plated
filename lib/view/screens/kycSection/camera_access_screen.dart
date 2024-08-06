import 'package:flutter/material.dart';
import 'package:Payrio/languageSection/Languages.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../theme/AppColor.dart';

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
        appBar: AppBar(toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            Languages.of(context)!.labelVerifyIdentity,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Languages.of(context)!.labelAllowCamAccess,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                SizedBox(height: 10),
                Text(
                  Languages.of(context)!.labelAllowAccessSubtitle,
                  style: TextStyle(fontSize: 14),
                ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_enhance,
                      size: 170,
                      color: Colors.black45,
                    ),
                  ],
                ),
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
                  Navigator.pushReplacementNamed(context, "/DocImageScreen",
                      arguments: "${docType}");
                } else {
                  requestPermission();
                }
              },
              child: Text(
                Languages.of(context)!.labelEnableCam,
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: AppColor.PRIMARY,
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
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }
    final permission = Permission.camera;
    PermissionStatus status = await permission.status;
    if (status.isDenied) {
      // Handle the case when permission is permanently denied
      openAppSettings();
    }
    return await isCameraGranted;
  }

  Future<void> requestPermission() async {
    final permission = Permission.camera;

    if (await permission.isDenied) {
      await permission.request();
    } else if (await permission.isGranted) {
      Navigator.pushReplacementNamed(context, "/DocImageScreen");
    }
  }
}
