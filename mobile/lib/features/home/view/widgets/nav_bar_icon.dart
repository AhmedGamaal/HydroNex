import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavBarIcon extends StatelessWidget {
  String iconName;

  NavBarIcon({required this.iconName});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$iconName.svg',
      height: 24,
      width: 24,
      fit: .scaleDown,
    );
  }
}
