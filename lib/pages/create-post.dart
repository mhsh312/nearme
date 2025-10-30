// create_post_screen.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location.dart';
import '../services/post.dart';
import '../services/cloudinary.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // State to hold the selected image file
  XFile? _selectedImage;
  // Controller for the description text field
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Function to handle image selection from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
      // Close the selection dialog/sheet if it's open
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  // UI to show image selection options
  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Gallery'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  // Empty function for the Post button (to be implemented later)
  void _handlePost() async {
    // Current UI-only implementation:
    final Position position = await LocationService().getCurrentUserLocation();

    String description = _descriptionController.text;
    XFile? image = _selectedImage;
    print('Post Data:');
    print('Image Selected: ${image != null}');
    print('Description: $description');
    print('lat: ${position.latitude}');
    print('long: ${position.longitude}');

    try {
      // Call the service method
      final imageUrl = await CloudinaryService().uploadImage(_selectedImage);
      print('YE RAHI IMAGE: $imageUrl');

      await PostService().createPost(
        description: description,
        latitude: position.latitude,
        longitude: position.longitude,
        imageUrl: imageUrl,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Post failed to publish: $e")));
    } finally {
      Navigator.pop(context);
    }

    // TODO: Implement logic to upload image (Cloud Storage) and save post (Firestore)
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if an image is selected and the description is not empty
    final bool isReadyToPost =
        _selectedImage != null && _descriptionController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
        actions: [
          // The "Post" button is enabled only when both an image and description exist
          TextButton(
            onPressed: isReadyToPost
                ? _handlePost
                : null, // onPressed is null if not ready
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 1. Image Selection Area
            GestureDetector(
              onTap: _showImageSourceActionSheet,
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap to select image/video',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // 2. Description Text Field
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Write a caption or description...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 5,
              maxLength: 100, // Example limit
              onChanged: (_) {
                // Rebuild the widget to update the Post button state
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
