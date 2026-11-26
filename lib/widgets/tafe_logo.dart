import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TafeLogo extends StatelessWidget {
  const TafeLogo({super.key, this.height = 40});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/tafe_logo_white.svg',
      height: height,
    );
  }
}
