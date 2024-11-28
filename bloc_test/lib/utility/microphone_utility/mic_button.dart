import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' show pi;

import '../../bloc/mic_cubit/mic_cubit.dart';
import '../../bloc/mic_cubit/mic_state.dart';

class MicButton extends StatefulWidget {
  const MicButton({super.key});

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  bool isPlaying = false;

  // rotation and scale animations
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  double _rotation = 0;
  double _scale = 0.85;

  bool get _showWaves => !_scaleController.isDismissed;

  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.85;

  @override
  void initState() {
    super.initState();
    _rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(() => setState(_updateRotation))
          ..repeat();

    _scaleController =
        AnimationController(vsync: this, duration: _kToggleDuration)
          ..addListener(() => setState(_updateScale));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _onToggle() {
    setState(() => isPlaying = !isPlaying);
    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
    }
  }

  Widget _buildIcon(bool isPlaying) {
    return SizedBox.expand(
      key: ValueKey<bool>(isPlaying),
      child: FloatingActionButton(
        heroTag: "audioButton",
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () async =>
            await context.read<MicCubit>().handleMicButtonPressed(),
        child: isPlaying ? const Icon(Icons.stop) : const Icon(Icons.mic),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MicCubit, MicState>(
      listener: (BuildContext context, state) {
        if (state is MicRecordingVoiceState ||
            state is MicWaitingAiResponseState) {
          _onToggle();
        }
      },
      child: SizedBox(
        height: 60,
        width: 60,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_showWaves) ...[
                Blob(
                    color: const Color(0xFF0F52A9),
                    scale: _scale,
                    rotation: _rotation),
                Blob(
                    color: const Color(0xFFAD394C),
                    scale: _scale,
                    rotation: _rotation * 2 - 30),
                Blob(
                    color: const Color(0xFF2EDD9C),
                    scale: _scale,
                    rotation: _rotation * 3 - 45),
                Blob(
                    color: const Color(0xFFC18AEF),
                    scale: _scale,
                    rotation: _rotation * 2 - 60),
              ],
              Container(
                constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: AnimatedSwitcher(
                  duration: _kToggleDuration,
                  child: _buildIcon(isPlaying),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Blob extends StatelessWidget {
  final double rotation;
  final double scale;
  final Color color;

  const Blob(
      {super.key, required this.color, this.rotation = 0, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(240),
              bottomLeft: Radius.circular(220),
              bottomRight: Radius.circular(180),
            ),
          ),
        ),
      ),
    );
  }
}
