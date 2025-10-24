import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  File? _imageFile;
  bool _isSepia = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<Uint8List?> _applyFilter(File file) async {
    final bytes = await file.readAsBytes();
    final original = img.decodeImage(bytes);
    if (original == null) return null;
    img.Image filtered;
    if (_isSepia) {
      filtered = img.sepia(original);
    } else {
      filtered = img.grayscale(original);
    }
    return Uint8List.fromList(img.encodeJpg(filtered));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick & Filter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: _pickImage,
          ),
          if (_imageFile != null) IconButton(
            icon: const Icon(Icons.filter),
            onPressed: () => setState(() => _isSepia = !_isSepia),
          ),
        ],
      ),
      body: Center(
        child: _imageFile == null
            ? const Text('No image selected.')
            : FutureBuilder<Uint8List?>(
          future: _applyFilter(_imageFile!),
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