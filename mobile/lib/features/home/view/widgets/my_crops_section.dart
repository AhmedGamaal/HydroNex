import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/features/crops/cubit/crop/crop_cubit.dart';
import 'package:hydronex_app/features/home/data/models/crop_model.dart';
import 'package:hydronex_app/features/home/view/widgets/crop_card.dart';

import '../../../../core/routes/app_routes.dart';

class MyCropsSection extends StatelessWidget {
  final List<CropModel> crops;

  const MyCropsSection({super.key, required this.crops});

  Future<void> openCropInfo(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.cropInfo,
      arguments: crops.first,
    );

    if (!context.mounted) return;

    if (result == true) {
      await context.read<CropCubit>().getCrops();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Crops', style: TextTheme.of(context).titleMedium),
        const SizedBox(height: 8),
        CropCard(crop: crops.first, onTap: () => openCropInfo(context)),
      ],
    );
  }
}
