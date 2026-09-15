import 'package:flutter/material.dart';

class AnalysisHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Smart Monitoring', style: textTheme.titleMedium),
        SizedBox(height: 4),
        Text('Real-time sensor monitoring', style: textTheme.titleSmall),
      ],
    );
  }
}
