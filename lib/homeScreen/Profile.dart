import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase storage
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capstone2/services/image_picker_service.dart'; // Import the image picker service
import 'home_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final RxBool isEdit = false.obs;
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final RxString email = ''.obs;
  File? _image;

  final ImagePickerService _imagePickerService = ImagePickerService(); // Initialize the image picker service

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  // Method to get the user email and fetch name, phone, and photoURL from Firestore
  void _getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email.value = user.email ?? '';

      // Fetch name, phone, and photoURL from Firestore
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        name.text = userData['name'] ?? '';
        phone.text = userData['phone'] ?? '';
        setState(() {
          _image = userData['photoURL'] != null ? File(userData['photoURL']) : null;
        });
      }
    }
  }

  // Method to save profile data and image to Firebase Storage and Firestore
  Future<void> _saveProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? imageUrl;

      // Upload image to Firebase Storage if available
      if (_image != null) {
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(user.uid + '_profile.jpg');
        await storageRef.putFile(_image!);

        // Get the image URL from Firebase Storage
        imageUrl = await storageRef.getDownloadURL();
      }

      // Save the updated name, phone, and photoURL to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': name.text,
        'phone': phone.text,
        'photoURL': imageUrl ?? FieldValue.delete(), // If image is removed, delete the field
      });

      _getUserEmail(); // Fetch updated data after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 530,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            // Image edit allowed only when isEdit is true
                            return GestureDetector(
                              onTap: isEdit.value
                                  ? () async {
                                File? pickedImage = await _imagePickerService.pickImage();
                                if (pickedImage != null) {
                                  setState(() {
                                    _image = pickedImage;
                                  });
                                }
                              }
                                  : null, // Disable tap if not in edit mode
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.background,
                                radius: 80,
                                backgroundImage: _image != null ? FileImage(_image!) : null,
                                child: _image == null
                                    ? const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                )
                                    : null,
                              ),
                            );
                          }),
                          const SizedBox(height: 10),
                          Obx(() {
                            // Show "Tap to change profile picture" only when isEdit is true
                            return isEdit.value
                                ? const Text(
                              "Tap to change profile picture",
                              style: TextStyle(color: Colors.grey),
                            )
                                : const SizedBox.shrink(); // Hide the text when not editing
                          }),
                          const SizedBox(height: 20),
                          Obx(
                                () => TextField(
                              controller: name,
                              enabled: isEdit.value,
                              decoration: InputDecoration(
                                filled: isEdit.value,
                                labelText: "Name",
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Obx(
                                () => TextField(
                              controller: TextEditingController(text: email.value),
                              enabled: false, // Email field is disabled
                              decoration: const InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.alternate_email),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Obx(
                                () => TextField(
                              controller: phone,
                              enabled: isEdit.value,
                              decoration: InputDecoration(
                                filled: isEdit.value,
                                labelText: "Number",
                                prefixIcon: const Icon(Icons.phone),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Obx(
                                () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isEdit.value
                                    ? PrimaryButton(
                                  btnName: 'Save',
                                  icon: const Icon(Icons.save),
                                  ontap: () async {
                                    isEdit.value = false;
                                    await _saveProfileData();
                                  },
                                )
                                    : PrimaryButton(
                                  btnName: 'Edit',
                                  icon: const Icon(Icons.edit),
                                  ontap: () {
                                    isEdit.value = true;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder for PrimaryButton widget (replace it with your actual widget)
class PrimaryButton extends StatelessWidget {
  final String btnName;
  final Icon icon;
  final VoidCallback ontap;

  const PrimaryButton({
    required this.btnName,
    required this.icon,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: ontap,
      icon: icon,
      label: Text(btnName),
    );
  }
}
