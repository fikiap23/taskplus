import 'dart:io';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskplus/services/user_data.dart';
import 'package:taskplus/services/user_service.dart';

class EditProfileController {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  String? imagePath;
  final UserService _userService = UserService();

  Future<void> loadUserData() async {
    Map<String, dynamic> userData = await UserData.getUserData() ?? {};
    print("User data loaded: $userData");
    idController.text = userData['_id'];
    nameController.text = userData['name'];
    profilePictureController.text = userData['profilePic'];
    usernameController.text = userData['username'];
    emailController.text = userData['email'];
    passwordController.text = userData['password'];
    newPasswordController.text = userData['password'];
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        // Set the _imagePath variable
        imagePath = pickedFile.path;
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> updateProfile() async {
    try {
      // Mengambil data dari controller
      String userId = idController.text;
      String name = nameController.text;
      String email = emailController.text;
      String username = usernameController.text;
      String password = passwordController.text;
      String profilePic;

      // Jika imagePath tidak null, gunakan imagePath sebagai profilePic
      // Jika imagePath null, gunakan nilai dari profilePictureController
      if (imagePath != null) {
        // Convert path file ke base64 string
        File imageFile = File(imagePath!);
        List<int> imageBytes = await imageFile.readAsBytes();
        String base64String = base64Encode(imageBytes);
        // print(base64String);
        profilePic = base64String;
      } else {
        profilePic = profilePictureController.text;
      }

      print(profilePic);
      // Membuat body request
      final Map<String, dynamic> requestBody = {
        'name': name,
        'email': email,
        'username': username,
        'password': password,
        'profilePic': profilePic,
      };

      await _userService.updateProfile(userId, requestBody);
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  Future<void> showImagePicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: Text("Camera"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
