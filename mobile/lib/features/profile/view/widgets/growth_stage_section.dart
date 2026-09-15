import 'package:flutter/material.dart';
import 'package:hydronex_app/features/profile/view/widgets/growth_stage_card.dart';

class GrowthStageSection extends StatelessWidget {
  const GrowthStageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> growthStages = [
      {
        'iconName': 'plant',
        'title': 'seedling',
        'description':
            'The plant has just sprouted from a seed. It’s tiny,\n fragile, and just\n starting to grow its first leaves,',

        'details':
            'Keep temperature warm (22-26°C). Keep EC very low (0.5-1.0) - too much nutrient overwhelms fragile roots. 9 Light should be gentle. This is the most fragile stage.',
      },
      {
        'iconName': 'vegetative',
        'title': 'Vegetative',
        'description':
            'The plant is growing leaves\n and stems rapidly. It’s\n building its\n structure before it starts\n making flowers or fruit.',
        'details':
            'Increase nutrient strength (EC 1.2-2.0).\n at 60-70%. This is when the plant grows fastest - it needs \nmaximum nutrition.\n Maintain humidity',
      },
      {
        'iconName': 'flowering',
        'title': 'Flowering',
        'description':
            'The plant starts making flowers. This is a critical stage -\n conditions here directly affect how much fruit or \nproduce you’ll \nget.',
        'details':
            'Reduce humidity to 50-60% to prevent bud rot. Adjust nutrients - lower nitrogen, higher phosphorus/potassium. Handle the plant gently to avoid dropping flowers.',
      },
      {
        'iconName': 'fruiting',
        'title': 'Fruiting',
        'description':
            'Flowers have been \npollinated and are now \ndeveloping into fruits \nor final produce. The plant \nis putting all its energy into \nthe \nharvest.',
        'details':
            'Maintain consistent EC and pH - fluctuations now can cause blossom end rot or splitting. Drop humidity to 40-50%. Watch maturity closely - harvest at the right time!',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Growth Stages', style: TextTheme.of(context).titleMedium),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GrowthStageCard(
                iconName: growthStages[0]['iconName']!,
                title: growthStages[0]['title']!,
                description: growthStages[0]['description']!,
                details: growthStages[0]['details']!,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: GrowthStageCard(
                iconName: growthStages[1]['iconName']!,
                title: growthStages[1]['title']!,
                description: growthStages[1]['description']!,
                details: growthStages[1]['details']!,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GrowthStageCard(
                iconName: growthStages[2]['iconName']!,
                title: growthStages[2]['title']!,
                description: growthStages[2]['description']!,
                details: growthStages[2]['details']!,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: GrowthStageCard(
                iconName: growthStages[3]['iconName']!,
                title: growthStages[3]['title']!,
                description: growthStages[3]['description']!,
                details: growthStages[3]['details']!,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
