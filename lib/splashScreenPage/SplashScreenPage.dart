import 'package:event/authPage/AuthPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splashscreenpage extends StatefulWidget {
  const Splashscreenpage({super.key});

  @override
  State<Splashscreenpage> createState() => _SplashscreenpageState();
}

class _SplashscreenpageState extends State<Splashscreenpage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Authpage()));
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Welcome to event managemet portal",
              style: TextStyle(
                fontSize: 45,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          const Text("LOADING....")
        ]),
      ),
    );
  }
}
