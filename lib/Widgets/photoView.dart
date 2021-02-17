import 'package:flutter/material.dart';

class PhotoView extends StatelessWidget {
  final url;
  final tag;
  PhotoView(this.url, this.tag);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: tag,
          child: Container(
            padding: EdgeInsets.all(4),
            child: Image.network(url, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
