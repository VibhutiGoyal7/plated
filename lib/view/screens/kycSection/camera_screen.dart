import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payrio/model/response/uploadKycResponse.dart';
import 'package:provider/provider.dart';

import '../../../model/apis/api_response.dart';
import '../../../view_model/media_view_model.dart';

class DocImageScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  DocImageScreen({Key? key, this.data}) : super(key: key);

  @override
  _DocImageScreenState createState() => _DocImageScreenState();
}

class _DocImageScreenState extends State<DocImageScreen> {
  bool frontImageClicked = false;
  bool backImgClicked = false;
  bool isBothSides = false;
  String docType = "";
  String imageName = "";
  File? frontImg;
  File? backImg;
  var imageUrl;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    docType = widget.data.toString();
    if (docType == "passport") {
      isBothSides = false;
      imageName = "customer_passport_image";
    } else if (docType == "national_id") {
      isBothSides = true;
      imageName = "customer_national_id_image";
    } else if (docType == "driving_licence") {
      isBothSides = true;
      imageName = "customer_driving_licence_image";
    } else if (docType == "video_kyc_clip") {
      isBothSides = false;
      imageName = "video_kyc";
    }
  }

  Future<Widget> getMediaWidget(
      BuildContext context, ApiResponse apiResponse) async {
    UploadKycDocResponse? mediaList = apiResponse.data as UploadKycDocResponse?;
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            //imageClicked = true;
            imageUrl = mediaList?.kycDocsImageUrl.toString();
            Navigator.pushNamed(context, "/ChooseDocScreen");
          });
        });
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text('Search for the song by Artist'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "${docType.toUpperCase()}",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(children: [
          GestureDetector(
              onTap: () {
                getFrontImage(ImageSource.camera);
              },
              child: Container(
                margin: EdgeInsets.only(left: 0, right: 00, bottom: 4, top: 0),
                alignment: Alignment.center,
                height: screenHeight * 0.6,
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(width: 0.2)),
                child: frontImageClicked
                    ? ClipRRect(
                        child: Image.file(frontImg as File,
                            width: screenWidth,
                            fit: BoxFit.fill),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Front Side"), Icon(Icons.add)],
                      ),
              )),
          if (isBothSides)
            GestureDetector(
                onTap: () {
                  getBackImage(ImageSource.camera);
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 0, right: 0, bottom: 10, top: 4),
                  alignment: Alignment.center,
                  height: screenHeight * 0.35,
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all(width: 0.5)),
                  child: backImgClicked
                      ? ClipRRect(
                          child: Image.file(backImg as File,
                              width: screenWidth,
                              fit: BoxFit.fill),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Back Side"), Icon(Icons.add)],
                        ),
                )),
          Spacer(),
          _buildFooter(context),
          SizedBox(height: 25,)
        ]));
  }

  Future<void> _uploadProfilePic(File file) async {
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MediaViewModel>(context, listen: false)
        .postMultiFormResponse(
            "/api/v1/app/kyc_documents", frontImg!, docType, imageName);
    ApiResponse apiResponse =
        Provider.of<MediaViewModel>(context, listen: false).response;
    getMediaWidget(context, apiResponse);
  }

  Future getFrontImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          setState(() {
            frontImg = File(pickedFile!.path);
            frontImageClicked = true;
          });
          print("image : ${frontImg}");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Picture not detected.')));
        }
      },
    );
  }

  Future getBackImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          setState(() {
            backImg = File(pickedFile!.path);
            backImgClicked = true;
          });
          print("image : ${backImg}");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Picture not detected.')));
        }
      },
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
                //Navigator.pushNamed(context, "/VideoKycScreen");
                if (frontImg != "") {
                  _uploadProfilePic(frontImg!);

                }
              },
              child: Text(
                "Submit",
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
}
