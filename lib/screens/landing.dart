import 'package:flutter/material.dart';
import 'package:taskplus/screens/Auth/login_screen.dart';
import 'package:taskplus/screens/Home/home_screen.dart';
import 'package:taskplus/services/user_data.dart';

class Landing extends StatelessWidget {
  const Landing({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Use a FutureBuilder to check if user data is present
      future: UserData.getUserData(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Check if user data is available
          if (snapshot.hasData && snapshot.data != null) {
            // User data is present, navigate to the home screen or any other initial screen
            return const HomeScreen();
          } else {
            // User data is not present, navigate to the login screen
            return const LoginScreen();
          }
        } else {
          // Future is still loading
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
