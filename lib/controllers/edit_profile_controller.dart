import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskplus/services/user_data.dart';

class EditProfileController {
  TextEditingController nameController = TextEditingController();
  TextEditingController profilePictureController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  String? imagePath;

  Future<void> loadUserData() async {
    Map<String, dynamic> userData = await UserData.getUserData() ?? {};
    print("User data loaded: $userData");
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

  Future<void> updateProfilePicture() async {
    print("Selected Image Path: $imagePath");
    // Implement logic to update profile picture here
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
                  updateProfilePicture();
                },
                child: Text("Camera"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                  updateProfilePicture();
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
