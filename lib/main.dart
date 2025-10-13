import 'package:animatedwarningmarquee/views/ai_caption_generator.dart';
import 'package:animatedwarningmarquee/views/animated_warning_marquee.dart';
import 'package:animatedwarningmarquee/views/quotes_home_screen.dart';
import 'package:animatedwarningmarquee/views/weather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugRepaintRainbowEnabled = false;
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
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => AICaptionGenerator(), // your target page
                        ),
                      );
                    },
                    child: const Text("Button 2"),
                  );
                },
              ),
              const SizedBox(height: 10),



              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => WeatherHomePage(), // your target page
                        ),
                      );
                    },
                    child: const Text("Button 2"),
                  );
                },
              ),


              const SizedBox(height: 10),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => QuoteHomePage(), // your target page
                        ),
                      );
                    },
                    child: const Text("Button 2"),
                  );
                },
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
