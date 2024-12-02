import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanCameraTextScreen extends StatefulWidget {
  @override
  State<ScanCameraTextScreen> createState() => _ScanCameraTextScreenState();
}

class _ScanCameraTextScreenState extends State<ScanCameraTextScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late final CameraDescription camera;

  @override
  void initState() {
    super.initState();

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePictureAndExtractText(BuildContext context) async {
    try {
      await _initializeControllerFuture;

      // Capture the image
      final image = await _cameraController.takePicture();

      if (image.path.isNotEmpty) {
        final text = await _extractTextFromImage(image.path);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TextDisplayScreen(text: text),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> _extractTextFromImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    return recognizedText.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture and Extract Text')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () => _takePictureAndExtractText(context),
      ),
    );
  }
}

class TextDisplayScreen extends StatelessWidget {
  final String text;

  const TextDisplayScreen({required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Extracted Text')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
