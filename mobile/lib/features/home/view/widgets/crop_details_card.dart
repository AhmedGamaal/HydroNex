import 'package:flutter/material.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/features/home/data/models/crop_model.dart';

class CropDetailsCard extends StatelessWidget {
  final CropModel crop;

  const CropDetailsCard({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(context, 'Crop Type :', crop.name),
          const SizedBox(height: 16),
          _buildDetailRow(context, 'Batch ID :', crop.batchId),
          const SizedBox(height: 16),
          _buildDetailRow(context, 'Location :', crop.location),
          const SizedBox(height: 16),
          _buildDetailRow(
            context,
            'Cycle Duration :',
            '${crop.totalDays} days',
          ),
          const SizedBox(height: 16),
          _buildDetailRow(context, 'Start Date :', crop.startDate),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
    final textTheme = TextTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.titleMedium),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
