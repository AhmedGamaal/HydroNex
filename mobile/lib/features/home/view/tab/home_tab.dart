import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/core/widgets/custom_button.dart';
import 'package:hydronex_app/features/alerts/cubit/alert/alert_cubit.dart';
import 'package:hydronex_app/features/crops/cubit/crop/crop_cubit.dart';
import 'package:hydronex_app/features/home/data/models/crop_model.dart';
import 'package:hydronex_app/features/home/view/widgets/home_header.dart';
import 'package:hydronex_app/features/home/view/widgets/my_crops_section.dart';
import 'package:hydronex_app/features/home/view/widgets/recent_alerts_section.dart';
import '../../../../core/routes/app_routes.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  Future<void> addCrop() async {
    final result = await Navigator.pushNamed(context, AppRoutes.addCrop);

    if (!mounted) return;

    if (result == true) {
      await context.read<CropCubit>().getCrops();
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<CropCubit>().getCrops();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<CropCubit, CropState>(
      listener: (context, state) {
        if (state.status == CropStatus.success && state.crops.isNotEmpty) {
          context.read<AlertCubit>().getAlertsByCropId(state.crops.first.id);
        }
      },
      child: BlocBuilder<CropCubit, CropState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            );
          }

          if (state.status == CropStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? 'Failed to load crops.'),
            );
          }

          final crops = state.crops
              .map((crop) => CropModel.fromResponse(crop))
              .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(),
                  const SizedBox(height: 24),

                  if (crops.isEmpty)
                    CustomButton(text: '+  Add Crop', onPressed: addCrop),

                  const SizedBox(height: 16),

                  if (crops.isNotEmpty) MyCropsSection(crops: crops),

                  if (crops.isNotEmpty)
                    BlocBuilder<AlertCubit, AlertState>(
                      builder: (context, alertState) {
                        if (alertState.alerts.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            RecentAlertsSection(cropId: crops.first.id),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
