import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/landing');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "TaskPlus ++",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Image(
                  image: AssetImage('assets/images/taskplus_logo.png'),
                )),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: LinearProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
