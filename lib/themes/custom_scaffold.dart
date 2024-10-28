import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? drawer;
  final String topImage;
  final String bottomImage;

  const CustomScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.drawer,
    this.topImage = "assets/main_top.png",
    this.bottomImage = "assets/cloud.png",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar: appBar,
      body: Stack(
        children: [
          // Background Images
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              topImage,
              width: 120,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: 0.4, // Set the desired opacity value (e.g., 0.2 for 20% opacity)
              child: Image.asset(
                bottomImage,
                width: 250,
              ),
            ),
          ),
          // Main content
          if (body != null)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: body,
              ),
            ),
        ],
      ),
    );
  }
}

