import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'loginScreen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Box _boxLogin = Hive.box("login");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login App", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3E497A),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0xFF3E497A),
              ),
              child: IconButton(
                onPressed: () {
                  _boxLogin.clear();
                  _boxLogin.put("loginStatus", false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      backgroundColor: const Color(0xFF21325E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome 🎉",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            const SizedBox(height: 10),
            Text(
              _boxLogin.get("userName"),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
