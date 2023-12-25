import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskplus/common/widgets/drawer_menu.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? _imagePath;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _updateProfilePicture() async {
    print("Selected Image Path: $_imagePath");
  }

  Future<void> _showImagePicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                  _updateProfilePicture();
                },
                child: Text("Camera"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                  _updateProfilePicture();
                },
                child: Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showImagePicker(context);
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imagePath != null
                        ? FileImage(File(_imagePath!))
                        : AssetImage("assets/images/user.png") as ImageProvider,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Username",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Enter your username",
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Email",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                ),
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              SizedBox(height: 20),
              Text(
                "Password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Text(
                "New Password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Enter your new password",
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
