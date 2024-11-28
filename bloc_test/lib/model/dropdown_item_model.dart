import 'package:flutter/cupertino.dart';

class DropdownItem {
  final IconData icon;
  final String label;
  final Function()? onTap;

  const DropdownItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}
