import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  XFile? snapshot;
  bool wasPhotoTaken = false;
  bool isAnalyzing = false;
  bool showAnalysisResult = false;
  String plantSpecies = "";
  int healthPercentage = 0;

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        cameraController = CameraController(_cameras.first, ResolutionPreset.high);
      });
      cameraController?.initialize().then((_) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCameraUI(),
    );
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<XFile?> takePicture() async {
    if (cameraController == null || cameraController?.value.isInitialized == false) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController?.value.isTakingPicture == true) {
      return null;
    }

    try {
      final XFile? file = await cameraController?.takePicture();
      return file;
    } on CameraException catch (e) {
      showInSnackBar(e.description ?? "Camera error");
      return null;
    }
  }

  // Simulate AI analysis
  Future<void> analyzeImage() async {
    setState(() {
      isAnalyzing = true;
    });

    // Simulate 2 second delay for analysis
    await Future.delayed(const Duration(seconds: 2));

    // Mock AI result - in a real app, this would come from an API or ML model
    setState(() {
      isAnalyzing = false;
      showAnalysisResult = true;
      plantSpecies = "Figowiec Benjamina";
      healthPercentage = 91;
    });
  }

  Widget buildPreview() {
    if (!wasPhotoTaken) {
      return CameraPreview(cameraController!);
    } else {
      if (snapshot == null) {
        return CameraPreview(cameraController!);
      } else {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image(image: XFileImage(snapshot!), fit: BoxFit.cover),

            // Show loading indicator or analysis results
            if (isAnalyzing)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 20),
                      const Text(
                        "Analizowanie rośliny...",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

            // Show analysis results overlay
            if (showAnalysisResult && !isAnalyzing)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        plantSpecies,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Stan zdrowia: ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "$healthPercentage%",
                            style: TextStyle(
                              color: healthPercentage > 80 ? Colors.green : Colors.yellow,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: healthPercentage / 100,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          healthPercentage > 80 ? Colors.green : Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }
    }
  }

  Widget _buildCameraUI() {
    if (cameraController == null || cameraController?.value.isInitialized == false) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: SizedBox.expand(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width,
              child: buildPreview(),
            ),
            if (!wasPhotoTaken)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: TextButton(
                    onPressed: () async {
                      XFile? newSnapshot = await takePicture();
                      setState(() {
                        snapshot = newSnapshot;
                        wasPhotoTaken = true;
                        showAnalysisResult = false;
                      });

                      // Start analysis after taking photo
                      if (newSnapshot != null) {
                        analyzeImage();
                      }
                    },
                    child: const Icon(Icons.photo_camera, size: 60, color: Colors.white70),
                  ),
                ),
              ),
            if (wasPhotoTaken)
              Positioned(
                top: 15,
                left: 15,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      wasPhotoTaken = false;
                      snapshot = null;
                      isAnalyzing = false;
                      showAnalysisResult = false;
                    });
                  },
                  child: const Icon(Icons.cancel_rounded, color: Colors.white70, size: 40),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}