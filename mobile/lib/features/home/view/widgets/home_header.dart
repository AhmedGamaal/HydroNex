import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);
    return Column(
      crossAxisAlignment: .start,
      children: [
        Image.asset('assets/images/hydronex.png'),
        SizedBox(height: 8),
        Text('Good morning,', style: textTheme.titleMedium),
        Row(
          children: [
            Text('Let’s grow something great ', style: textTheme.titleSmall),
            SvgPicture.asset('assets/icons/plant.svg'),
          ],
        ),
      ],
    );
  }
}
