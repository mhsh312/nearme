import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nearme/services/post.dart';
import 'create-post.dart';
import '../services/auth.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late Future<List<Map<String, dynamic>>> _postsFuture;
  @override
  void initState() {
    super.initState();
    // Start the initial data fetch
    _postsFuture = PostService().fetchPosts();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _postsFuture = PostService().fetchPosts();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Near Me"), backgroundColor: Colors.amber),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: FutureBuilder(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error loading posts: ${snapshot.error}'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return NoPostsFound();
            } else {
              return ListView.builder(
                physics:
                    const AlwaysScrollableScrollPhysics(), // RefreshIndicator ke liye chahiye
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return PostCard(post: snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
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

class NoPostsFound extends StatelessWidget {
  const NoPostsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        physics:
            AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works even when empty
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No posts found. Pull down to check again!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    final String username = post['userId'];
    final String imageUrl = post['imageUrl'];
    final String caption = post['description'];
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Profile
          ListTile(
            leading: const CircleAvatar(child: FaIcon(FontAwesomeIcons.user)),
            title: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.more_vert),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          ),

          // Display the post image
          Image.network(
            imageUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 300,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          ),

          // Like, Comment, Share
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.heart),
                  onPressed: () {},
                  iconSize: 28,
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.comment),
                  onPressed: () {},
                  iconSize: 28,
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.paperPlane),
                  onPressed: () {},
                  iconSize: 28,
                ),
                const Spacer(),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.bookmark),
                  onPressed: () {},
                  iconSize: 28,
                ),
              ],
            ),
          ),

          // Caption
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 12.0),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: '$username ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
