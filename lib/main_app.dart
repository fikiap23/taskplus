import 'package:flutter/material.dart';
import 'package:taskplus/screens/Auth/login_screen.dart';
import 'package:taskplus/screens/Auth/signup_screen.dart';
import 'package:taskplus/screens/Home/home_screen.dart';
import 'package:taskplus/screens/Notes/notes_screen.dart';
import 'package:taskplus/screens/Tasks/tasks_screen.dart';

import 'package:taskplus/services/user_data.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          headlineLarge: TextStyle(color: Colors.black),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(242, 244, 255, 1),
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.lightBlue,
          onPrimary: Colors.white,
          secondary: Colors.lightBlue,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.blue,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.blue,
            ),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
      home: FutureBuilder(
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
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/tasks': (context) => const TasksPage(),
        '/notes': (context) => const NotesScreen(),
      },
    );
  }
}
