import 'package:bloc_test/bloc/mic_cubit/mic_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrazySwitch extends StatefulWidget {
  final String text1;
  final String text2;

  const CrazySwitch({
    super.key,
    required this.text1,
    required this.text2,
  });

  @override
  State<CrazySwitch> createState() => _CrazySwitchState();
}

class _CrazySwitchState extends State<CrazySwitch> {
  late bool isPorcuActive;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isPorcuActive = context.read<MicCubit>().shouldPorcuBeActive;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        isPorcuActive ? Text(widget.text1) : Text(widget.text2),
        Switch(
            inactiveThumbColor: Colors.red,
            activeColor: Colors.green,
            value: isPorcuActive,
            onChanged: (newValue) async {
              final isChanged =
                  await context.read<MicCubit>().togglePorcupine();
              if (isChanged == true) {
                setState(() {
                  isPorcuActive = newValue;
                });
              }
            }),
      ],
    );
  }
}
