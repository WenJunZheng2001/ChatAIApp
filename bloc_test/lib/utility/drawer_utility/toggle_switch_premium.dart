import 'package:bloc_test/bloc/mic_cubit/mic_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CrazySwitchPremium extends StatefulWidget {
  final String text1;
  final String text2;

  const CrazySwitchPremium({
    super.key,
    required this.text1,
    required this.text2,
  });

  @override
  State<CrazySwitchPremium> createState() => _CrazySwitchPremiumState();
}

class _CrazySwitchPremiumState extends State<CrazySwitchPremium> {
  late bool isPremium;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isPremium = context.read<MicCubit>().isPremium;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        isPremium ? Text(widget.text1) : Text(widget.text2),
        Switch(
            inactiveThumbColor: Colors.red,
            activeColor: Colors.green,
            value: isPremium,
            onChanged: (newValue) {
              final isChanged = context.read<MicCubit>().changeToPremium();
              if (isChanged == true) {
                setState(() {
                  isPremium = newValue;
                });
              }
            }),
      ],
    );
  }
}
