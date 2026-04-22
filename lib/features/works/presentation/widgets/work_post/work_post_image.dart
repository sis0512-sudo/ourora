import 'package:flutter/material.dart';

class WorkPostImage extends StatelessWidget {
  final String url;

  const WorkPostImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(url, fit: BoxFit.contain);
  }
}
