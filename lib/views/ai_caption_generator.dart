import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AICaptionGenerator extends StatefulWidget {
  const AICaptionGenerator({super.key});

  @override
  State<AICaptionGenerator> createState() => _AICaptionGeneratorState();
}

class _AICaptionGeneratorState extends State<AICaptionGenerator> {
  Uint8List? _imageBytes; // Works for both web and mobile
  String? _caption;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();

  // Pick image for mobile + web
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _caption = null;
      });
    }
  }

  // Generate AI caption
  Future<void> _generateCaption() async {
    if (_imageBytes == null) return;

    setState(() {
      _loading = true;
      _caption = null;
    });

    try {
      // ⚠ Web: Do NOT expose API key. Use backend proxy in production.
      final apiKey = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

      final base64Image = base64Encode(_imageBytes!);

      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/responses"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4.1-mini",
          "input": [
            {
              "role": "user",
              "content": [
                {
                  "type": "input_text",
                  "text":
                  "Generate a short, creative caption for this image."
                },
                {
                  "type": "input_image",
                  "image_data": base64Image,
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final output = data["output"][0]["content"][0]["text"];
        setState(() {
          _caption = output;
        });
      } else {
        setState(() {
          _caption = "Failed: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _caption = "Error: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = _imageBytes != null
        ? Image.memory(
      _imageBytes!,
      fit: BoxFit.cover, // Change to BoxFit.contain / fill / etc. if needed
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
    )
        : const Center(
      child: Text(
        'Tap to select an image',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('AI Caption Generator'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8, // 80% screen height
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageWidget,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loading ? null : _generateCaption,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.auto_awesome, color: Colors.white),
                label: _loading
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Generate Caption',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 25),
              if (_caption != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _caption!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
