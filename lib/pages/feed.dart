import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'create-post.dart';
import '../services/auth.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Near Me"), backgroundColor: Colors.amber),
      body: Column(),
      bottomNavigationBar: BottomAppBar(
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePostScreen()),
            );
          },
          icon: FaIcon(FontAwesomeIcons.plus),
        ),
      ),
    );
  }
}
