// list mosque_images from folder assets/mosque_images dynamically
import 'package:flutter/services.dart';

Future<List<String>> getMosqueImages() async {
  final images = <String>[];

  for (int i = 1; i <= 10; i++) {
    try {
      final imagePath = 'assets/mosque_images/images-$i.jpg';
      // Check if the file exists in the assets
      await rootBundle.load(imagePath);
      images.add(imagePath);
    } catch (e) {
      // Log the error if the file does not exist
      // print('Error loading image: $imagePath - $e');
    }
  }

  if (images.isEmpty) {
    // If no images found, add a default image
    images.add('assets/mosque_images/default.jpg');
  }

  // print('Loaded mosque images: ${images.length}');

  return images;
}
