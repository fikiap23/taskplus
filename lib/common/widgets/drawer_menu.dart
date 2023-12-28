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
            child: FutureBuilder<Map<String, dynamic>?>(
              future: UserData.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: Text('Error loading user data'),
                  );
                } else {
                  String name = snapshot.data!['name'] ?? '';
                  String email = snapshot.data!['email'] ?? '';

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        decoration: BoxDecoration(color: Colors.blue),
                        accountName: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        accountEmail: Text(
                          email,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Color(0xFF4B6AAB),
                          child: Image(
                              image: snapshot.data!['profilePic'].isNotEmpty
                                  ? NetworkImage(snapshot.data!['profilePic'])
                                  : AssetImage('assets/images/user.png')
                                      as ImageProvider),
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
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
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
                            MaterialPageRoute(
                                builder: (context) => TasksPage()),
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
                            MaterialPageRoute(
                                builder: (context) => NotesScreen()),
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
                            MaterialPageRoute(
                                builder: (context) => EditProfile()),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout,
            ),
            title: const Text('Logout'),
            onTap: () async {
              bool isLogout = await UserData.deleteUserData();
              bool isToken = await UserData.deleteToken();
              if (isLogout && isToken) {
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
