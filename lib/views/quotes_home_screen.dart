import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart'; // for Clipboard

class QuoteHomePage extends StatefulWidget {
  const QuoteHomePage({super.key});

  @override
  State<QuoteHomePage> createState() => _QuoteHomePageState();
}

class _QuoteHomePageState extends State<QuoteHomePage> {
  String? quote;
  String? author;
  bool loading = false;

  /// Fetch quote from type.fit API (CORS-friendly)
  Future<void> fetchQuote() async {
    setState(() => loading = true);
    try {
      final url = Uri.parse("https://type.fit/api/quotes");
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        final randomQuote = data[Random().nextInt(data.length)];
        setState(() {
          quote = randomQuote["text"];
          author = randomQuote["author"] ?? "Unknown";
        });
      } else {
        showSnack("Failed to load quote 😢");
      }
    } catch (e) {
      showSnack("Error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  void showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  /// Share quote (mobile/desktop) or copy to clipboard (web)
  void shareQuote() {
    if (quote == null) return;

    final text = '"$quote" — $author';
    if (kIsWeb) {
      Clipboard.setData(ClipboardData(text: text));
      showSnack("Quote copied to clipboard!");
    } else {
      Share.share(text);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("💭 AI Quote of the Day"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: loading
              ? const CircularProgressIndicator()
              : quote == null
              ? const Text("No quote found 😕")
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie animation
              Lottie.network(
                "https://assets10.lottiefiles.com/packages/lf20_cloud.json",
                height: 180,
              ),
              const SizedBox(height: 20),
              Text(
                "\"$quote\"",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "- $author",
                style: const TextStyle(
                    fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: fetchQuote,
                    icon: const Icon(Icons.refresh),
                    label: const Text("New Quote"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: shareQuote,
                    icon: const Icon(Icons.share),
                    label: Text(kIsWeb ? "Copy" : "Share"),
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
