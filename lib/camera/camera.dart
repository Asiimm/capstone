import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:capstone2/homeScreen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  int _selectedCameraIndex = 0; // Track the active camera

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isNotEmpty) {
        _initializeCameraController(cameras![_selectedCameraIndex]);
      }
    } catch (e) {
      print('Error initializing cameras: $e');
    }
  }

  Future<void> _initializeCameraController(CameraDescription cameraDescription) async {
    _cameraController = CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera controller: $e');
    }
  }

  void _switchCamera() {
    if (cameras!.length > 1) {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras!.length;
      _initializeCameraController(cameras![_selectedCameraIndex]);
    }
  }

  Future<File?> _captureImage() async {
    if (!_isCameraInitialized || _cameraController == null) return null;
    try {
      final file = await _cameraController!.takePicture();
      return File(file.path);
    } catch (e) {
      print('Error capturing image: $e');
      return null;
    }
  }

  Future<void> _uploadImageToFirebase(File image) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userId = user.uid;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance.ref().child('user_photos/$userId/$fileName.jpg');

    try {
      await storageRef.putFile(image);
      String downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('photos')
          .add({'url': downloadUrl, 'timestamp': Timestamp.now()});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image.')),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the transform matrix based on the camera index
    Matrix4 transformMatrix;

    if (_selectedCameraIndex == 1) {
      // Apply mirroring for the front camera
      transformMatrix = Matrix4.identity()..rotateY(pi);
    } else {
      // No flip for back camera
      transformMatrix = Matrix4.identity();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: _isCameraInitialized
          ? Center(
        child: Transform(
          alignment: Alignment.center,
          transform: transformMatrix,
          child: CameraPreview(_cameraController!),
        ),
      )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            child: Icon(Icons.camera),
            onPressed: () async {
              File? imageFile = await _captureImage();
              if (imageFile != null) {
                await _uploadImageToFirebase(imageFile);
              }
            },
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            child: Icon(Icons.cameraswitch),
            onPressed: _switchCamera,
          ),
        ],
      ),
    );
  }
}
