import 'package:flutter/material.dart';

import '../../model/dropdown_item_model.dart';

class CustomDropdownMenu extends StatefulWidget {
  final IconData? icon;
  final String label;
  final List<DropdownItem> dropdownItems;

  const CustomDropdownMenu({
    super.key,
    this.icon,
    required this.label,
    required this.dropdownItems,
  });

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  late List<bool> _isPressedList;

  bool _isExpanded = false;
  Color? _labelColor = Colors.grey[800];

  @override
  void initState() {
    super.initState();
    _isPressedList =
        List.generate(widget.dropdownItems.length, (index) => false);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
                _labelColor = _isExpanded ? Colors.grey[500] : Colors.grey[800];
                if (_isExpanded) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (widget.icon != null)
                  Icon(
                    widget.icon,
                    size: 35,
                  ),
                const SizedBox(
                  width: 8,
                  height: 8,
                ),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: _labelColor,
                  ),
                ),
                const Spacer(),
                RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 0.5).animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                  child: const Icon(
                    Icons.expand_more,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: _animation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.dropdownItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Imposta lo stato di pressione solo per l'elemento toccato
                        _isPressedList[index] = !_isPressedList[index];
                      });
                      item.onTap?.call();
                      //Navigator.pop(context);
                    },
                    onTapDown: (TapDownDetails details) {
                      // Inizia l'animazione quando il tocco inizia
                      setState(() {
                        _isPressedList[index] = true;
                      });
                    },
                    onTapUp: (TapUpDetails details) {
                      // Termina l'animazione quando il tocco finisce
                      setState(() {
                        _isPressedList[index] = false;
                      });
                      // Esegui altre azioni se necessario
                      Navigator.pop(context);
                    },
                    onTapCancel: () {
                      // Se il tocco viene cancellato, termina l'animazione
                      setState(() {
                        _isPressedList[index] = false;
                      });
                    },
                    child: ListTile(
                      leading: Icon(
                        item.icon,
                        size: 25,
                      ),
                      title: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: _isPressedList[index] ? 10 : 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
