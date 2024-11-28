
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryWidget extends StatefulWidget {
  final List<String> urlImages;
  final int index;

  const GalleryWidget(
      {super.key, required this.urlImages, required this.index});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: "Close",
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0x001c1b20)
              : const Color(0x00fffbff),
        ),
        pageController: pageController,
        itemCount: widget.urlImages.length,
        builder: (context, index) {
          final urlImage = widget.urlImages[index];
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedMemoryImageProvider(
              urlImage,
              base64: urlImage,
            ),
            // imageProvider: CachedNetworkImageProvider(urlImage),
          );
        },
      ),
    );
  }
}
