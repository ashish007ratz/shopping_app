import 'package:flutter/material.dart';

class FullScreenImagePopup extends StatelessWidget {
  final String imageUrl;
  final String tag;
  const FullScreenImagePopup(this.imageUrl, this.tag);

  @override
  Widget build(BuildContext context) {
    return  Material(
      // type: MaterialType.transparency,
      color: Colors.grey.withOpacity(0.6),
      child: Hero(
        tag: tag,
        child: InteractiveViewer(
          // Enable zooming and panning
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain, // Adjust fit for zooming
          ),
        ),
      ),
    );
  }
}