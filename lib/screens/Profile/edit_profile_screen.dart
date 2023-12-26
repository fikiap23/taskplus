import 'dart:io';

import 'package:flutter/material.dart';

import 'package:taskplus/common/widgets/drawer_menu.dart';
import 'package:taskplus/controllers/edit_profile_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final EditProfileController _editProfileController = EditProfileController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _editProfileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          IconButton(
            onPressed: () async {
              await _editProfileController.updateProfile();
              // Navigator.pop(context);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: _editProfileController.loadUserData(),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          await _editProfileController.showImagePicker(context);
                          setState(() {});
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              _editProfileController.imagePath != null
                                  ? FileImage(
                                      File(_editProfileController.imagePath!))
                                  : _editProfileController
                                          .profilePictureController
                                          .text
                                          .isNotEmpty
                                      ? NetworkImage(
                                          _editProfileController
                                              .profilePictureController.text,
                                        )
                                      : AssetImage("assets/images/user.png")
                                          as ImageProvider,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Name",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _editProfileController.nameController,
                      decoration: InputDecoration(
                        hintText: "Enter your name",
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Username",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _editProfileController.usernameController,
                      decoration: InputDecoration(
                        hintText: "Enter your username",
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Email",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _editProfileController.emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      readOnly: true,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Password",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _editProfileController.passwordController,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "New Password",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _editProfileController.newPasswordController,
                      decoration: InputDecoration(
                        hintText: "Enter your new password",
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
