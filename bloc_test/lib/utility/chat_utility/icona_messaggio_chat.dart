import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/image_constants.dart';

class IconMessageChat extends StatelessWidget {
  final bool isMessageSentByMe;
  final String? photoUrl;
  final bool isAnimating;

  const IconMessageChat(
      {super.key,
      required this.isMessageSentByMe,
      required this.photoUrl,
      required this.isAnimating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: isMessageSentByMe
          ? photoUrl == null
              ? SizedBox(
                  height: 29,
                  width: 29,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      userImageIcon,
                      gaplessPlayback: true,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : SizedBox(
                  height: 29,
                  width: 29,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CircleAvatar(
                      backgroundImage: Image(
                        image: CachedNetworkImageProvider(photoUrl ?? ""),
                        gaplessPlayback: true,
                        fit: BoxFit.cover,
                      ).image,
                    ),
                  ),
                )
          : isAnimating
              ? SizedBox(
                  width: 29,
                  height: 29,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      chatBotIcon,
                      gaplessPlayback: true,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : SizedBox(
                  width: 29,
                  height: 29,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      botFixedIcon,
                      gaplessPlayback: true,
                      fit: BoxFit.cover,
                    ),
                  )),
    );
  }
}
