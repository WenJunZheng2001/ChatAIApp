import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../model/upload_file_model.dart';

class GalleryUserWidget extends StatefulWidget {
  final List<UploadFileIconModel> urlImages;
  final int index;

  const GalleryUserWidget(
      {super.key, required this.urlImages, required this.index});

  @override
  State<GalleryUserWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryUserWidget> {
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
          return PhotoViewGalleryPageOptions.customChild(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                widget.urlImages[index].isImage
                    ? Image.file(
                        File(widget.urlImages[index].iconToDisplay),
                      )
                    : Image.asset(
                        widget.urlImages[index].iconToDisplay,
                        height: 500,
                        width: 500,
                      ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: widget.urlImages.isNotEmpty &&
                            !widget.urlImages[index].isImage
                        ? Text(
                            widget.urlImages[index].fileName,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
