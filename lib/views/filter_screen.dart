import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class FilterApp extends StatelessWidget {
  const FilterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Filter',
      home: const FilterHomePage(),
    );
  }
}

class FilterHomePage extends StatefulWidget {
  const FilterHomePage({super.key});

  @override
  State<FilterHomePage> createState() => _FilterHomePageState();
}

class _FilterHomePageState extends State<FilterHomePage> {
  Uint8List? _imageBytes;
  bool _isSepia = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List bytes;
      if (kIsWeb) {
        bytes = await pickedFile.readAsBytes(); // Web uses bytes
      } else {
        bytes = await pickedFile.readAsBytes(); // Mobile also reads as bytes
      }
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<Uint8List?> _applyFilter(Uint8List bytes) async {
    final original = img.decodeImage(bytes);
    if (original == null) return null;

    final filtered = _isSepia ? img.sepia(original) : img.grayscale(original);
    return Uint8List.fromList(img.encodeJpg(filtered));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick & Filter'),
        actions: [
          IconButton(icon: const Icon(Icons.photo), onPressed: _pickImage),
          if (_imageBytes != null)
            IconButton(
                icon: const Icon(Icons.filter),
                onPressed: () => setState(() => _isSepia = !_isSepia)),
        ],
      ),
      body: Center(
        child: _imageBytes == null
            ? const Text('No image selected.')
            : FutureBuilder<Uint8List?>(
          future: _applyFilter(_imageBytes!),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return Image.memory(snapshot.data!);
            }
            return const Text('Error applying filter.');
          },
        ),
      ),
    );
  }
}
