import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydronex_app/core/routes/app_routes.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/features/crops/cubit/crop/crop_cubit.dart';
import 'package:hydronex_app/features/crops/data/crop_service.dart';
import 'package:hydronex_app/features/home/data/models/crop_model.dart';
import 'package:hydronex_app/features/home/view/widgets/crop_card.dart';
import 'package:hydronex_app/features/home/view/widgets/crop_details_card.dart';

class CropInfoScreen extends StatelessWidget {
  static const String routeName = AppRoutes.cropInfo;

  final CropModel crop;

  const CropInfoScreen({super.key, required this.crop});

  Future<void> _deleteCrop(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.cream,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/delete.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Delete Crop',
                style: TextTheme.of(context).titleLarge?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this crop?\n'
            'This action cannot be undone.',
            style: TextTheme.of(context).bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text('Cancel', style: TextStyle(color: AppTheme.primary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.criticalBackground,
                foregroundColor: AppTheme.criticalText,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) return;

    context.read<CropCubit>().deleteCrop(crop.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CropCubit(repository: CropService.createRepository()),
      child: BlocListener<CropCubit, CropState>(
        listener: (context, state) {
          if (state.status == CropStatus.deleteSuccess) {
            Navigator.pop(context, true);
          }

          if (state.status == CropStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to delete crop.'),
              ),
            );
          }
        },
        child: BlocBuilder<CropCubit, CropState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Crop Info'),
                actions: [
                  IconButton(
                    onPressed: state.isLoading
                        ? null
                        : () => _deleteCrop(context),
                    icon: SvgPicture.asset(
                      'assets/icons/delete.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CropCard(crop: crop),
                    const SizedBox(height: 16),
                    CropDetailsCard(crop: crop),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
