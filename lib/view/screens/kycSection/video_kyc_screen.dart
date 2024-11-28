import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/api_response.dart';
import '../../../theme/AppColor.dart';
import '../../../utils/Util.dart';
import '../../../view_model/main_view_model.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';

class VideoKycScreen extends StatefulWidget {

  VideoKycScreen({Key? key}) : super(key: key);

  @override
  _VideoKycScreenState createState() => _VideoKycScreenState();
}

class _VideoKycScreenState extends State<VideoKycScreen> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  String docType = '';
  late File? imageFile;
  final picker = ImagePicker();
  bool isVideoRecorded = false;
  late File videoFile;
  var videoUrl;
  bool isDarkMode = false;
  static const maxDuration = Duration(seconds: 2);
  bool isCompressing = false;
  bool isLoading = false;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    docType = "";
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  /*Future<Widget> vidKycUploadResponse(
      BuildContext context, ApiResponse apiResponse) async
  {
    UploadKycDocResponse? mediaList = apiResponse.data as UploadKycDocResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(
            child: CircularProgressIndicator(
          color: isDarkMode ? AppColor.WHITE : AppColor.PRIMARY,
        ));
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
        if (nonCapitalizeString("${apiResponse?.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}"))
          SessionExpiredDialog.showDialogBox(context: context);
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }*/

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
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (Platform.isIOS) {
            if (details.velocity.pixelsPerSecond.dx > 50) {
              if (isKeyboardOpen(context)) {
                hideKeyBoard();
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  "/ChooseDocScreen",
                );
              }
            }
          }
        },
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 65,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/ChooseDocScreen");
                },
              ),
              title: Text(
                "Verify your Identity",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: AppColor.PRIMARY,
                statusBarIconBrightness:
                    Brightness.light, // Change icon brightness
              ),
            ),
            body: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                left: 0, right: 0, bottom: 4, top: 10),
                            alignment: Alignment.center,
                            height: screenHeight * 0.65,
                            width: double.infinity,
                            child: isVideoRecorded
                                ? videoPlayerController != null &&
                                        videoPlayerController
                                            .value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio: videoPlayerController
                                            .value.aspectRatio,
                                        child: FutureBuilder<double>(
                                          future: _getRotationAngle(
                                              videoPlayerController.value),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Transform.rotate(
                                                angle: snapshot.data!,
                                                child: VideoPlayer(
                                                    videoPlayerController),
                                              );
                                            } else {
                                              return VideoPlayer(
                                                  videoPlayerController); // Default video display
                                            }
                                          },
                                        ),
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
                    )),
                isLoading
                    ? Stack(
                        children: [
                          // Block interaction
                          ModalBarrier(
                              dismissible: false, color: Colors.transparent),
                          // Loader indicator
                          Center(
                            child: CircularProgressIndicator(
                              color: isDarkMode
                                  ? AppColor.WHITE
                                  : AppColor.PRIMARY,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            )),
      ),
    );
  }

 /* Future<void> _uploadProfilePic(File file) async {
    await Future.delayed(Duration(milliseconds: 2));
    print("docType: ${docType}");
    await Provider.of<MainViewModel>(context, listen: false)
        .postMultiFormResponse(
      "/api/v1/app/kyc_documents",
      imageFile as File,
      docType,
      videoFile,
    );
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
   // vidKycUploadResponse(context, apiResponse);
  }*/

  Widget _buildScreen(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Image(
            alignment: Alignment.topLeft,
            //width: 25,
            height: MediaQuery.of(context).size.height * 0.2,
            image: AssetImage("assets/video-recording.png"),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Record a video",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "This is to verify you are a real person",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "1. First position your face in the frame.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "2. Then, turn your head slowly to both sides.",
              style: TextStyle(fontSize: 14),
            ),
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
                /* setState(() {
                  isVideoRecorded = true;
                });*/
                if (isVideoRecorded) {
                  setState(() {
                    isLoading = true;
                  });

                  bool isConnected = await _connectivityService.isConnected();
                  if (!isConnected) {
                    setState(() {
                      isLoading = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${Languages.of(context)?.labelNoInternetConnection}'),
                          duration: maxDuration,
                        ),
                      );
                    });
                  } else {
                    if (videoFile != null || videoFile != "") {
                      setState(() {
                        isVideoRecorded = true;
                      });
                     // _uploadProfilePic(videoFile);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Could not record video."),
                          duration: maxDuration,
                        ),
                      );
                    }
                  }
                } else {
                  _startVideo(ImageSource.camera);
                }
              },
              child: Text(
                isVideoRecorded ? "Submit" : "Start Recording",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  backgroundColor: Theme.of(context).cardColor,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
            ),
          ),
        ],
      ),
    );
  }

  Future<double> _getRotationAngle(VideoPlayerValue videoValue) async {
    // If you know the video always rotates, you can adjust the angle directly
    // e.g., rotating 90 degrees if needed.

    // Here are some angles based on common rotations
    // You can adjust this based on how your video rotates
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt == 31) {
      // Rotate for Android 12 or higher
      if (videoValue.size.width > videoValue.size.height) {
        return 90 * 3.14159265358979323846 / 180; // 90 degrees rotation
      } else {
        return 90 * 3.14159265358979323846 / 180; // No rotation needed
      }
    } else {
      return 0.0; // No rotation for Android versions below 12
    }
    if (videoValue.size.width > videoValue.size.height) {
      return 90 * 3.14159265358979323846 / 180; // Rotating by 90 degrees
    } else {
      return 90 * 3.14159265358979323846 / 180; // No rotation needed
    }
  }

  Future _startVideo(ImageSource img) async {
    final pickedFile = await picker.pickVideo(
      source: img,
      maxDuration: const Duration(seconds: 10),
      preferredCameraDevice: CameraDevice.front,
    );
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          setState(() {
            videoFile = File(pickedFile!.path);
            //compressAndPlayVideo(videoFile);
            // videoPlayerController = VideoPlayerController.file(videoFile)
            //   ..initialize().then((_) {
            //     setState(() {
            //       final duration = videoPlayerController?.value.duration;
            //       if (duration != null && duration < Duration(seconds: 5)) {
            //         // Handle the case where the video is too short
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(
            //               content: Text(
            //                   'Video is too short. Minimum duration is 5 seconds.')),
            //         );
            //         isVideoRecorded = false;
            //
            //         // Optionally, you can delete the video file if it doesn't meet your criteria
            //         File(xfilePick.path).delete();
            //       } else {
            //         videoPlayerController.play(); //.pause() for pausing
            //         videoPlayerController.setVolume(0.0);
            //         isVideoRecorded = true;
            //       }
            //     });
            //   });
            // setState(() {});
          });
          print("image : ${videoFile}");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Video not detected.')));
        }
      },
    );
  }

  /*Future<void> compressAndPlayVideo(File file) async
  {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    // Compress the video
    final MediaInfo? compressedVideoInfo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality, // Adjust quality as needed
      deleteOrigin: false,
    );

    if (compressedVideoInfo != null && compressedVideoInfo.file != null) {
      File compressedFile = compressedVideoInfo.file!;
      videoPlayerController = VideoPlayerController.file(compressedFile)
        ..initialize().then((_) {
          setState(() {
            final duration = videoPlayerController.value.duration;
            if (duration != null && duration < Duration(seconds: 5)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Video is too short. Minimum duration is 5 seconds.')),
              );
              isVideoRecorded = false;
              compressedFile.delete();
            } else {
              videoPlayerController.play();
              videoPlayerController.setVolume(0.0);
              isVideoRecorded = true;
            }
            isLoading = false; // Hide loader after initialization
          });
        });
    } else {
      setState(() {
        isLoading = false; // Hide loader if compression fails
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compression failed.')),
      );
    }
  }*/
}
