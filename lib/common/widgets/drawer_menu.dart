import 'package:flutter/material.dart';
import 'package:taskplus/screens/Home/home_screen.dart';
import 'package:taskplus/screens/Notes/notes_screen.dart';

import 'package:taskplus/screens/Auth/login_screen.dart';
import 'package:taskplus/screens/Profile/edit_profile_screen.dart';

import 'package:taskplus/screens/Tasks/tasks_screen.dart';
import 'package:taskplus/services/user_data.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF4B6AAB)),
                  accountName: Text(
                    "Fiki Aprian",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    "fikiaprian23@gmail.com",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Color(0xFF4B6AAB),
                    child: Image(image: AssetImage('assets/images/user.png')),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                  ),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.task,
                  ),
                  title: const Text('Tasks'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TasksPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.library_books,
                  ),
                  title: const Text('Notes'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotesScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                  ),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(), // Add a divider for visual separation
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Logout'),
            onTap: () async {
              bool isLogout = await UserData.deleteUserData();
              if (isLogout) {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
