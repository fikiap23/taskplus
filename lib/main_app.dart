import 'package:flutter/material.dart';
import 'package:taskplus/screens/Auth/login_screen.dart';
import 'package:taskplus/screens/Home/home_screen.dart';
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
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
        ),
        scaffoldBackgroundColor: const Color(0xFF21325E),
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF3E497A),
          onPrimary: Colors.white,
          secondary: Color(0xFF3E497A),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Color(0xFF21325E),
          onBackground: Colors.white,
          surface: Color(0xFF21325E),
          onSurface: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Color(0xFFF1D00A),
            ),
            foregroundColor: MaterialStateProperty.all(Colors.black),
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
              return const HomePage();
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
    );
  }
}
