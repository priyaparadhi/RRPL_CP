import 'package:flutter/material.dart';

class FullImagePage extends StatelessWidget {
  final String imageUrl;

  FullImagePage({required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Image'),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl), // Use the same image here
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
