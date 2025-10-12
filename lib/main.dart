import 'package:animatedwarningmarquee/views/animated_warning_marquee.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Animated Warning Marquee')),
        body: const Center(
          child: AnimatedWarningMarquee(
            text: '⚠️ Do not close your app during this process ⚠️',
            backgroundColor: Colors.orangeAccent,
            scrollDuration: Duration(seconds: 10),
          ),
        ),
      ),
    );
  }
}
