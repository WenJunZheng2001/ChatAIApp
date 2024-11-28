import 'package:flutter/material.dart';

class ListViewMic extends StatelessWidget {
  final String text;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets padding;

  const ListViewMic(
      {super.key,
      required this.text,
      required this.mainAxisAlignment,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Flexible(
              child: SelectableText(
                text,
                style:
                    const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                onSelectionChanged: (selection, cause) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
