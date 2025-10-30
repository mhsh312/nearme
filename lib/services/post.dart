import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  // Get a reference to the 'posts' collection in Firestore
  final CollectionReference _postsCollection = FirebaseFirestore.instance
      .collection('posts');

  /// Uploads a new post document to the 'posts' collection in Firestore.
  ///
  /// Takes:
  /// - [description]: The user's text content.
  /// - [latitude]: The location's latitude (as a double).
  /// - [longitude]: The location's longitude (as a double).
  Future<void> createPost({
    required String description,
    required double latitude,
    required double longitude,
    required String imageUrl,
  }) async {
    // 1. Create a Map representing the post document data
    final Map<String, dynamic> postData = {
      'description': description,
      'location': GeoPoint(latitude, longitude),
      'timestamp': FieldValue.serverTimestamp(), // Firestore sets the time
      'imageUrl': imageUrl, // Placeholder for future image logic
      // TODO: Add 'userId' when authentication is implemented
    };

    try {
      // 2. Add the document to the 'posts' collection
      await _postsCollection.add(postData);
      print("Post successfully uploaded to Firestore!");
    } on FirebaseException catch (e) {
      // Handle potential errors (e.g., permission denied, network issues)
      print("Error creating post: ${e.message}");
      rethrow; // Re-throw the error so the calling widget can handle it
    }
  }
}
