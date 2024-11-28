import 'package:flutter/material.dart';

class TabCategory extends StatefulWidget {
  final String imagePath;
  final String categoria;

  const TabCategory(
      {super.key, required this.imagePath, required this.categoria});

  @override
  State<TabCategory> createState() => _TabCategoryState();
}

class _TabCategoryState extends State<TabCategory> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        // Inizia l'animazione quando il tocco inizia
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (TapUpDetails details) {
        // Termina l'animazione quando il tocco finisce
        setState(() {
          _isPressed = false;
        });
        // Esegui altre azioni se necessario
        Navigator.pop(context);
      },
      onTapCancel: () {
        // Se il tocco viene cancellato, termina l'animazione
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            ListTile(
              leading: Image.asset(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                widget.imagePath,
                width: 30,
                height: 30,
                scale: _isPressed
                    ? 50
                    : 13, // Riduci la dimensione dell'image quando premuto
              ),
              title: Text(
                widget.categoria,
                style: TextStyle(
                  fontSize: _isPressed ? 10 : 13,
                  fontWeight: FontWeight.normal,
                  // color: Colors.grey[800],
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
