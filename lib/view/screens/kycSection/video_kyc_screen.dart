import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../model/apis/api_response.dart';
import '../../../model/response/uploadKycResponse.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/session_expired_dialog.dart';

class VideoKycScreen extends StatefulWidget {
  final String? data; // Define the 'data' parameter here

  VideoKycScreen({Key? key, this.data}) : super(key: key);

  @override
  _VideoKycScreenState createState() => _VideoKycScreenState();
}

class _VideoKycScreenState extends State<VideoKycScreen> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  String docType = '';
  final picker = ImagePicker();
  bool isVideoRecorded = false;
  late File frontImg;
  var videoUrl;

  @override
  void initState() {
    super.initState();
    docType = widget.data.toString();

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
            videoUrl = mediaList?.kycDocsImageUrl.toString();
          });
        });
        Navigator.pushReplacementNamed(context, "/ChooseDocScreen");
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:

        if(mediaList?.message== "Invalid access token")
          SessionExpiredDialog.showDialogBox(context: context);
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

  Future<bool> _onWillPop() async {
    // Navigate to the desired screen
    Navigator.pushReplacementNamed(
      context,
      "/ChooseDocScreen",
    );
    return false; // Prevent the default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop ,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/ChooseDocScreen");
              },
            ),
            title: Text(
              "Verify your Identity",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Container(
                      margin:
                          EdgeInsets.only(left: 0, right: 0, bottom: 4, top: 10),
                      alignment: Alignment.center,
                      height: screenHeight * 0.65,
                      width: double.infinity,
                      child: isVideoRecorded
                          ? videoPlayerController != null &&
                                  videoPlayerController.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio:
                                      videoPlayerController.value.aspectRatio,
                                  child: VideoPlayer(videoPlayerController),
                                )
                              : Text('No video selected')
                          : GestureDetector(
                              onTap: () {
                                _startVideo(ImageSource.camera);
                              },
                              child: _buildScreen(context))),
                  Spacer(),
                  _buildFooter(context)
                ],
              ))),
    );
  }

  Future<void> _uploadProfilePic(File file) async {
    await Future.delayed(Duration(milliseconds: 2));
    await Provider.of<MainViewModel>(context, listen: false)
        .postMultiFormResponse("/api/v1/app/kyc_documents", frontImg!,
            "video_kyc_clip", "kyc_file");
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getMediaWidget(context, apiResponse);
  }

  Widget _buildScreen(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Image(
            alignment: Alignment.topLeft,
            //width: 25,
            height: MediaQuery.of(context).size.height*0.2,
            image: AssetImage("assets/video-recording.png"),
          ),
        ),
        SizedBox(height: 25,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Record a video", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
            SizedBox(height: 10,),
            Text("This is to verify you are a real person", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
            SizedBox(height: 6,),
            Text("1. First position your face in the frame.", style: TextStyle(fontSize: 14),),
            SizedBox(height: 6,),
            Text("2. Then, turn your head slowly to both sides.", style: TextStyle(fontSize: 14),),
          ],
        ),
      ],
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
                if(isVideoRecorded)
                _uploadProfilePic(frontImg);
                else _startVideo(ImageSource.camera);
              },
              child: Text(
                isVideoRecorded ? "Submit" : "Start Recording",
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

  Future _startVideo(ImageSource img) async {
    final pickedFile = await picker.pickVideo(
      source: img,
      maxDuration: const Duration(seconds: 15),
    );
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          setState(() {
            frontImg = File(pickedFile!.path) as File;
            videoPlayerController = VideoPlayerController.file(frontImg)
              ..initialize().then((_) {
                setState(() {});
                videoPlayerController.play(); //.pause() for pausing
                videoPlayerController.setVolume(0.0);
              });
            setState(() {});
            isVideoRecorded = true;
          });
          print("image : ${frontImg}");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Video not detected.')));
        }
      },
    );
  }
}
