import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  final CollectionReference _postsCollection = FirebaseFirestore.instance
      .collection('posts');

  Future<void> createPost({
    required String userId,
    required String description,
    required double latitude,
    required double longitude,
    required String imageUrl,
  }) async {
    final Map<String, dynamic> postData = {
      'userId': userId,
      'description': description,
      'location': GeoPoint(latitude, longitude),
      'timestamp': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
    };

    try {
      await _postsCollection.add(postData);
      print("Post successfully uploaded to Firestore!");
    } on FirebaseException catch (e) {
      print("Error creating post: ${e.message}");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    try {
      final QuerySnapshot snapshot = await _postsCollection
          .orderBy('timestamp', descending: true)
          .limit(15)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }
}
