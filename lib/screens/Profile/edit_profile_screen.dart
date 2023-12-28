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
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          IconButton(
            onPressed: () async {
              // Menampilkan loading menggunakan showDialog
              showDialog(
                context: context,
                barrierDismissible:
                    false, // user harus menunggu sampai loading selesai
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Saving profile..."),
                      ],
                    ),
                  );
                },
              );

              // Memanggil updateProfile
              await _editProfileController.updateProfile(context);

              // Menutup dialog saat proses selesai
              Navigator.pop(context);

              // Memperbarui widget
              setState(() {});
            },
            icon: const Icon(Icons.save),
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
                          backgroundImage: _editProfileController.imagePath !=
                                  null
                              ? FileImage(
                                  File(_editProfileController.imagePath!))
                              : _editProfileController
                                      .profilePictureController.text.isNotEmpty
                                  ? NetworkImage(
                                      _editProfileController
                                          .profilePictureController.text,
                                    )
                                  : const AssetImage("assets/images/user.png")
                                      as ImageProvider,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Name",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _editProfileController.nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Username",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _editProfileController.usernameController,
                      decoration: const InputDecoration(
                        hintText: "Enter your username",
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Email",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _editProfileController.emailController,
                      decoration: const InputDecoration(
                        hintText: "Enter your email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "New Password",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _editProfileController.newPasswordController,
                      decoration: const InputDecoration(
                        hintText: "Enter your new password",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(color: Colors.black),
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
