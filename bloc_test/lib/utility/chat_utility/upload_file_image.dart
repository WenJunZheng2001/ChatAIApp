import 'package:flutter/material.dart';
import 'dart:io';

import '../../model/upload_file_model.dart';
import 'gallery_image_from_user.dart';

class UploadedFilePhoto extends StatelessWidget {
  final List<UploadFileIconModel> listOfFileIcon;
  const UploadedFilePhoto({
    super.key,
    required this.listOfFileIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 40),
      color: Colors.transparent,
      height: 50,
      width: 100,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: listOfFileIcon.length,
        separatorBuilder: (context, index) => const SizedBox(
          width: 2.0,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async => await openGallery(context, index),
            child: Stack(
              children: [
                listOfFileIcon[index].isImage
                    ? Image.file(File(listOfFileIcon[index].iconToDisplay))
                    : Image.asset(listOfFileIcon[index].iconToDisplay),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${index + 1}/${listOfFileIcon.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
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
      builder: (context) => GalleryUserWidget(
        urlImages: listOfFileIcon,
        index: index,
      ),
    ));
  }
}
