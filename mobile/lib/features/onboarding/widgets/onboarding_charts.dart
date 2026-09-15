import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydronex_app/core/widgets/chart_card.dart';

class OnboardingCharts extends StatelessWidget {
  const OnboardingCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      bottom: 360,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ChartCard(
            asset: 'assets/images/Graphi&Grid.svg',
          ),
          const SizedBox(height: 16),
          const ChartCard(
            asset: 'assets/images/Chart&Axis.svg',
          ),
          const SizedBox(height: 16),
          ChartCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/MainChart.svg',
                ),
                const SizedBox(height: 3),
                SvgPicture.asset(
                  'assets/images/LineLegends.svg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

