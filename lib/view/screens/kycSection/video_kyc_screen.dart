import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoKycScreen extends StatefulWidget {

  final String? data; // Define the 'data' parameter here

  VideoKycScreen({Key? key, this.data}) : super(key: key);
  @override
  _VideoKycScreenState createState() => _VideoKycScreenState();
}

class _VideoKycScreenState extends State<VideoKycScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  String docType = '';
  final picker = ImagePicker();
  bool frontImageClicked = false;
  File? frontImg;

  @override
  void initState() {
    super.initState();
    docType = widget.data.toString();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        frontImg.toString(),
      ),
    );

    _initializeVideoPlayerFuture = _controller.initialize();

  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

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
              children: [
            Container(
            margin: EdgeInsets.only(left: 10, right: 10,bottom: 4,top: 10),
          alignment: Alignment.center,
          height: screenHeight * 0.35,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(width: 1)),
          child: frontImageClicked
              ?  FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ): Text("Video clip")),
                _buildFooter(context)
              ],
            )
        )
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
                _startVideo(ImageSource.camera);
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
  Future _startVideo(ImageSource img) async {
      final pickedFile = await picker.pickVideo(source: img, maxDuration: const Duration(seconds: 15),);
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
                const SnackBar(content: Text('Video not detected.')));
          }
        },
      );
  }
}