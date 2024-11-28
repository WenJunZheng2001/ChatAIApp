import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

Future<String?> showLangDialog(
  BuildContext context,
  String title,
  List<LocaleName> myLangList,
) {
  String? selectedLang;
  return showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            children: [
              DropdownMenu(
                  onSelected: (value) {
                    selectedLang = value;
                  },
                  dropdownMenuEntries: <DropdownMenuEntry>[
                    const DropdownMenuEntry(
                      value: null,
                      label: "my input lang",
                    ),
                    for (final lang in myLangList)
                      DropdownMenuEntry(
                        value: lang.localeId,
                        label: lang.name,
                      )
                  ]),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedLang);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(selectedLang);
              },
              child: const Text("Si"),
            ),
          ],
        );
      }).then((value) => value);
}
