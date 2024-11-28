import 'package:flutter/material.dart';

Future<String?> showAiLangDialog(
  BuildContext context,
  String title,
  List<dynamic> myLangList,
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
                      label: "ai accent",
                    ),
                    for (final lang in myLangList)
                      DropdownMenuEntry(
                        value: lang.toString(),
                        label: lang.toString(),
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
