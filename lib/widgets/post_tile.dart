import 'package:flutter/material.dart';
import '../models/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  const PostTile({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(post.body),
    );
  }
}
