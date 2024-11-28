import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';

import 'gallery_image_from_ai.dart';

class ImageListFromAi extends StatelessWidget {
  final List<String> listOfImages;
  const ImageListFromAi({super.key, required this.listOfImages});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 42.5),
      margin: const EdgeInsets.only(top: 10),
      height: 150,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listOfImages.length,
        separatorBuilder: (context, index) => const SizedBox(
          width: 10.0,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async => await openGallery(context, index),
            child: Stack(
              children: [
                Image(
                  image: CachedMemoryImageProvider(
                    listOfImages[index],
                    base64: listOfImages[index],
                  ),
                  gaplessPlayback: true,
                ),

                // CachedNetworkImage(
                //   imageUrl: listOfImages[index],
                //   placeholder: (context, url) => const SizedBox(
                //       width: 150,
                //       height: 150,
                //       child: Center(child: CircularProgressIndicator())),
                //   errorWidget: (context, url, error) => const SizedBox(
                //     width: 100,
                //     height: 100,
                //     child: Center(child: Icon(Icons.error)),
                //   ),
                // ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${index + 1}/${listOfImages.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> openGallery(BuildContext context, int index) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GalleryWidget(
        urlImages: listOfImages,
        index: index,
      ),
    ));
  }
}
