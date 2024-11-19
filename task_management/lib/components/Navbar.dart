import 'package:flutter/material.dart';

class NavBarIcon extends StatelessWidget {
  const NavBarIcon({
    super.key,
    required this.text,
    required this.imagePath,
    required this.selected,
    required this.onPressed,
    this.selectedColor = const Color(0xffFF8527),
    this.defaultColor = Colors.black54,
  });

  final String text;
  final String imagePath;
  final bool selected;
  final Function() onPressed;
  final Color defaultColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            selected ? selectedColor : defaultColor,
            BlendMode.srcIn,
          ),
          child: Image.asset(
            imagePath,
            width: 25,
            height: 25,
          ),
        ),
      ),
    );
  }
}
