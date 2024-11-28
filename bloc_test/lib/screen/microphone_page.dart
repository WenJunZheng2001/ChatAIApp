import 'package:bloc_test/constants/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:siri_wave/siri_wave.dart';

import '../bloc/mic_cubit/mic_cubit.dart';
import '../bloc/mic_cubit/mic_state.dart';
import '../utility/microphone_utility/list_view_mic.dart';

class MicrophoneContent extends StatefulWidget {
  final String? photoUrl;

  const MicrophoneContent({super.key, required this.photoUrl});

  @override
  State<MicrophoneContent> createState() => _MicrophoneContentState();
}

class _MicrophoneContentState extends State<MicrophoneContent> {
  final String text = "Ciao, dì 'Ehi Lisa' per iniziare una conversazione";

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MicCubit, MicState>(
      builder: (context, state) {
        if (state is MicErrorState) {
          return const Center(
            child: Text("qualcosa e andato storto"),
          );
        }
        if (state is MicRecordingVoiceState) {
          return Center(
            child: Column(
              children: [
                Text(state.myWords),
                SiriWaveform.ios9(
                  controller: IOS9SiriWaveformController(
                    amplitude: 0.5,
                    speed: 0.15,
                  ),
                  options: const IOS9SiriWaveformOptions(
                    showSupportBar: true,
                    height: 580,
                    // width: 360,
                  ),
                ),
              ],
            ),
          );
        }
        if (state is MicWaitingAiResponseState) {
          return Center(
              child: Theme.of(context).brightness == Brightness.dark
                  ? Lottie.asset('assets/images/mic_icon/loading_white.json',
                      width: 100, height: 100)
                  : Lottie.asset('assets/images/mic_icon/loading_black.json',
                      width: 100, height: 100));
        }

        if (state is MicReceivedAiResponseState) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  ListViewMic(
                    text: state.myQuestion,
                    mainAxisAlignment: MainAxisAlignment.end,
                    padding: const EdgeInsets.only(left: 100),
                  ),
                  ListViewMic(
                    text: state.aiResponse,
                    mainAxisAlignment: MainAxisAlignment.start,
                    padding: const EdgeInsets.only(right: 100),
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? bulletPointWhiteIcon
                    : bulletPointIcon,
                height: 50,
                width: 50,
              ),
            ],
          ),
        );
      },
    );
  }
}
