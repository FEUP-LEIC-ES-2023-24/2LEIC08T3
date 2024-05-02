import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingScreen extends StatelessWidget {
  final String loadingMessage;

  const CustomLoadingScreen({
    Key? key,
    this.loadingMessage = "Calculating...",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitWaveSpinner(
              color: Colors.green,
              size: 50.0,
            ),
            const SizedBox(height: 20),
            Text(
              loadingMessage,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            )
          ],
        ),
      ),
    );
  }
}