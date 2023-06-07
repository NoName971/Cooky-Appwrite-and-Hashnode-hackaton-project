import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/appwrite_constants.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewView extends ConsumerStatefulWidget {
  const ImagePreviewView({super.key, required this.imagePath});

  final String imagePath;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImagePreviewViewState();
}

class _ImagePreviewViewState extends ConsumerState<ImagePreviewView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PhotoView(
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 1.5,
          enablePanAlways: false,
          imageProvider: CachedNetworkImageProvider(
            AppwriteConstants.imageUrl(widget.imagePath),
          ),
        ),
      ),
    );
  }
}
