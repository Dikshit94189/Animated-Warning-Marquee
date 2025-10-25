import 'package:animatedwarningmarquee/views/ai_caption_generator.dart';
import 'package:animatedwarningmarquee/views/animated_warning_marquee.dart';
import 'package:animatedwarningmarquee/views/filter_screen.dart';
import 'package:animatedwarningmarquee/views/lottie_task.dart';
import 'package:animatedwarningmarquee/views/quotes_home_screen.dart';
import 'package:animatedwarningmarquee/views/weather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Five Buttons Example',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5 Buttons Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const AnimatedWarningMarquee()),
              ),
              child: const Text("Button 1"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const AICaptionGenerator()),
              ),
              child: const Text("Button 2"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const WeatherHomePage()),
              ),
              child: const Text("Button 3"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const QuoteHomePage()),
              ),
              child: const Text("Button 4"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const CounterHomePage()),
              ),
              child: const Text("Button 5"),
                ),const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const FilterApp()),
                  ),
                  child: const Text("Button 6"),
                ),
          ],
        ),
      ),
    );
  }
}
