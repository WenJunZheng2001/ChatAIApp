import 'dart:math';

import 'package:flutter/material.dart';

bool toggle = true;

class AnimatedPopup extends StatefulWidget {
  const AnimatedPopup({
    super.key,
  });

  @override
  State<AnimatedPopup> createState() => _AnimatedPopupState();
}

class _AnimatedPopupState extends State<AnimatedPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  bool isInvisible = false;
  bool isTextVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 275),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment alignment1 = const Alignment(0.0, 0.0);
  Alignment alignment2 = const Alignment(0.0, 0.0);
  Alignment alignment3 = const Alignment(0.0, 0.0);
  Alignment alignment4 = const Alignment(0.0, 0.0);
  double size1 = 50.0;
  double size2 = 50.0;
  double size3 = 50.0;
  double size4 = 50.0;

  void closeAll() {
    setState(() {
      toggle = !toggle;
      _controller.reverse();
      alignment1 = const Alignment(0.0, 0.0);
      alignment2 = const Alignment(0.0, 0.0);
      alignment3 = const Alignment(0.0, 0.0);
      alignment4 = const Alignment(0.0, 0.0);
      size1 = size2 = size3 = size4 = 20.0;
      isInvisible = !isInvisible;
      isTextVisible = !isTextVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Stack(
        children: [
          if (Theme.of(context).brightness == Brightness.light)
            AnimatedAlign(
              duration: toggle
                  ? const Duration(milliseconds: 275)
                  : const Duration(milliseconds: 875),
              curve: toggle ? Curves.easeIn : Curves.elasticOut,
              alignment: toggle ? Alignment.topCenter : Alignment.topLeft,
              child: SizedBox(
                height: toggle ? 50.0 : 40.0,
                width: toggle ? 50.0 : 40.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey,
                        offset: Offset(0, 65),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          isInvisible
              ? _buildPopupButton(
                  Icons.file_upload, "File Upload", alignment1, size1, () {
                  print("file_upload");
                  closeAll();
                })
              : const SizedBox.shrink(),
          isInvisible
              ? _buildPopupButton(Icons.image, "Image", alignment2, size2, () {
                  print("image");
                  closeAll();
                })
              : const SizedBox.shrink(),
          isInvisible
              ? _buildPopupButton(Icons.camera_alt, "Camera", alignment3, size3,
                  () {
                  print("camera");
                  closeAll();
                })
              : const SizedBox.shrink(),
          isInvisible
              ? _buildPopupButton(
                  Icons.access_alarm, "Alarm", alignment4, size4, () {
                  print("alarm");
                  closeAll();
                })
              : const SizedBox.shrink(),
          AnimatedAlign(
            duration: toggle
                ? const Duration(milliseconds: 275)
                : const Duration(milliseconds: 875),
            curve: toggle ? Curves.easeIn : Curves.elasticOut,
            alignment: toggle ? Alignment.center : Alignment.centerLeft,
            child: Transform.rotate(
              angle: _animation.value * pi * (3 / 4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 375),
                curve: Curves.easeOut,
                height: toggle ? 50.0 : 40.0,
                width: toggle ? 50.0 : 40.0,
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.circular(60.0),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    splashColor: Colors.black54,
                    splashRadius: 31.0,
                    onPressed: () {
                      setState(() {
                        if (toggle) {
                          toggle = !toggle;
                          _controller.forward();
                          Future.delayed(const Duration(milliseconds: 10), () {
                            alignment1 = const Alignment(-0.3, -1.0);
                            size1 = 50.0;
                          });
                          Future.delayed(const Duration(milliseconds: 100), () {
                            alignment2 = const Alignment(0.0, -0.4);
                            size2 = 50.0;
                          });
                          Future.delayed(const Duration(milliseconds: 10), () {
                            alignment3 = const Alignment(-0.3, 1.0);
                            size3 = 50.0;
                          });
                          Future.delayed(const Duration(milliseconds: 100), () {
                            alignment4 = const Alignment(0.0, 0.4);
                            size4 = 50.0;
                          });
                          isInvisible = !isInvisible;
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              isTextVisible = !isTextVisible;
                            });
                          });
                        } else {
                          toggle = !toggle;
                          _controller.reverse();
                          alignment1 = const Alignment(0.0, 0.0);
                          alignment2 = const Alignment(0.0, 0.0);
                          alignment3 = const Alignment(0.0, 0.0);
                          alignment4 = const Alignment(0.0, 0.0);
                          size1 = size2 = size3 = size4 = 20.0;
                          isInvisible = !isInvisible;
                          isTextVisible = !isTextVisible;
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupButton(IconData icon, String text, Alignment alignment,
      double size, VoidCallback onPressed) {
    return AnimatedAlign(
      duration: toggle
          ? const Duration(milliseconds: 275)
          : const Duration(milliseconds: 875),
      alignment: alignment,
      curve: toggle ? Curves.easeIn : Curves.elasticOut,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            height: 40,
            width: 40,
            duration: const Duration(milliseconds: 275),
            curve: toggle ? Curves.easeIn : Curves.easeOut,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                tooltip: text,
                icon: Icon(
                  icon,
                  size: 15,
                  color: Colors.white,
                ),
                onPressed: onPressed,
              ),
            ),
          ),
          const SizedBox(width: 5),
          // if (isTextVisible)
          //   AnimatedTextKit(
          //     totalRepeatCount: 1,
          //     onTap: onPressed,
          //     animatedTexts: [
          //       TyperAnimatedText(text),
          //     ],
          //   ),
        ],
      ),
    );
  }
}
