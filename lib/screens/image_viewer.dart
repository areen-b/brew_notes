import 'package:flutter/material.dart';
import 'package:brew_notes/theme.dart';

class ImageViewerPage extends StatelessWidget {
  final String imageUrl;

  const ImageViewerPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteFoam(context),
      appBar: AppBar(
        backgroundColor: AppColors.latteFoam(context),
        iconTheme: IconThemeData(color: AppColors.brown(context)),
        elevation: 0,
        toolbarHeight: 35,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: InteractiveViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox.expand(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}