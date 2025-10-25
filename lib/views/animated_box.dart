import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class AnimatedBoxPage extends StatefulWidget {
  const AnimatedBoxPage({super.key});

  @override
  State<AnimatedBoxPage> createState() => _AnimatedBoxPageState();
}

class _AnimatedBoxPageState extends State<AnimatedBoxPage> {
  double _size = 100;
  Color _color = Colors.blue;
  double _borderRadius = 12;

  void _changeBox() {
    final random = Random();
    setState(() {
      _size = random.nextDouble() * 200 + 100; // 100–300
      _color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );
      _borderRadius = random.nextDouble() * 64;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Animated Box 🎨"),
        centerTitle: true,
      ),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _changeBox,
        label: const Text("Animate"),
        icon: const Icon(Icons.play_arrow),
      ),
    );
  }
}
