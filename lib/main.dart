import 'package:animatedwarningmarquee/views/animated_warning_marquee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ✅ Single class with 5 buttons
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Five Buttons Example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('5 Buttons Example'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => AnimatedWarningMarquee(), // your target page
                        ),
                      );
                    },
                    child: const Text("Button 1"),
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  print("Button 2 pressed");
                },
                child: const Text("Button 2"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  print("Button 3 pressed");
                },
                child: const Text("Button 3"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  print("Button 4 pressed");
                },
                child: const Text("Button 4"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  print("Button 5 pressed");
                },
                child: const Text("Button 5"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
