import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CounterHomePage extends StatefulWidget {
  const CounterHomePage({super.key});

  @override
  State<CounterHomePage> createState() => _CounterHomePageState();
}

class _CounterHomePageState extends State<CounterHomePage> {
  int _count = 0;

  void _increment() {
    setState(() => _count++);
  }

  void _decrement() {
    if (_count > 0) setState(() => _count--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Counter'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_count > 0)
                Lottie.network(
                  'https://assets1.lottiefiles.com/packages/lf20_jcikwtux.json',
                  width: 150,
                  height: 150,
                  repeat: true,
                ),
              Text(
                'Count:',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '$_count',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _decrement,
                    icon: const Icon(Icons.remove),
                    label: const Text('Decrease'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: _increment,
                    icon: const Icon(Icons.add),
                    label: const Text('Increase'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}