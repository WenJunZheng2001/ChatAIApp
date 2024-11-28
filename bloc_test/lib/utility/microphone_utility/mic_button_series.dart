import 'package:bloc_test/utility/dialog_utility/lang_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../bloc/mic_cubit/mic_cubit.dart';
import '../../constants/image_constants.dart';
import '../../screen/chat_page.dart';
import '../dialog_utility/ai_lang_dialog.dart';

class MicButtonSeries extends StatelessWidget {
  final String? photoUrl;
  const MicButtonSeries({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        SpeedDial(
          heroTag: "speedDialMic",
          buttonSize: const Size(50, 50),
          // childPadding: const EdgeInsets.only(left: 5),
          animationDuration: const Duration(milliseconds: 375),
          childrenButtonSize: const Size(50, 50),
          spacing: 3,
          switchLabelPosition: true,
          icon: Icons.add,
          activeIcon: Icons.close,
          overlayColor: Colors.black,
          overlayOpacity: 0,
          animationCurve: Curves.elasticInOut,
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.black,
          // openCloseDial: isDialOpen,
          children: [
            SpeedDialChild(
              shape: const CircleBorder(),
              child: const Icon(
                Icons.language,
              ),
              label: "Cambia lingua",
              onTap: () async {
                final selectedLang = await showLangDialog(
                  context,
                  "Cambia lingua",
                  context.read<MicCubit>().localLanguages,
                );

                if (context.mounted) {
                  context.read<MicCubit>().changeLang(selectedLang);
                }
              },
            ),
            SpeedDialChild(
              shape: const CircleBorder(),
              child: const Icon(
                Icons.translate,
              ),
              onTap: () async {
                final selectedLang = await showAiLangDialog(
                  context,
                  "Cambia lingua",
                  context.read<MicCubit>().localLangAi,
                );

                if (context.mounted) {
                  await context.read<MicCubit>().changeAiLang(selectedLang);
                }
              },
              label: "Accento lingua",
            ),
            // SpeedDialChild(
            //   shape: const CircleBorder(),
            //   child: const Icon(
            //     Icons.camera_alt,
            //   ),
            //   onTap: () {},
            //   label: "Camera",
            // ),
            // SpeedDialChild(
            //   shape: const CircleBorder(),
            //   child: const Icon(
            //     Icons.access_alarm,
            //   ),
            //   onTap: () {},
            //   label: "Alarm",
            // ),
          ],
        ),
        const Spacer(),
        IconButton(
            onPressed: () async {
              await context.read<MicCubit>().handleMicButtonPressed();
            },
            icon: const Icon(Icons.mic)),
        const Spacer(),
        Transform.scale(
          scale: 0.5,
          child: FloatingActionButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatContent(photoUrl: photoUrl)));

              // Navigator.pop(context);
            },
            heroTag: "chatButton",
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            child: Image.asset(
              chatMicIcon,
              width: 24,
              height: 24,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
