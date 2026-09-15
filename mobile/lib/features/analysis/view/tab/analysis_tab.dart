import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/network/api_client.dart';
import 'package:hydronex_app/core/storage/token_storage.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/features/analysis/data/datasources/analysis_remote_data_source.dart';
import 'package:hydronex_app/features/analysis/data/repositories/analysis_repository_impl.dart';
import 'package:hydronex_app/features/analysis/view/widgets/analysis_header.dart';
import 'package:hydronex_app/features/analysis/view/widgets/environment_trends_card.dart';
import 'package:hydronex_app/features/analysis/view/widgets/live_status_card.dart';
import 'package:hydronex_app/features/analysis/view/widgets/sensor_card.dart';
import 'package:hydronex_app/features/analysis/view/widgets/sensors_status_card.dart';
import 'package:hydronex_app/features/analysis/view_model/analysis_view_model.dart';
import 'package:hydronex_app/features/crops/cubit/crop/crop_cubit.dart';

class AnalysisTab extends StatefulWidget {
  const AnalysisTab({super.key});

  @override
  State<AnalysisTab> createState() => _AnalysisTabState();
}

class _AnalysisTabState extends State<AnalysisTab>
    with AutomaticKeepAliveClientMixin {
  late AnalysisViewModel viewModel;

  bool hasCrop = false;
  bool isLoadingCrop = false;

  @override
  void initState() {
    super.initState();

    final tokenStorage = const TokenStorage();

    final Dio dio = ApiClient.create(tokenStorage: tokenStorage);

    final repository = AnalysisRepositoryImpl(
      remoteDataSource: AnalysisRemoteDataSource(dio: dio),
    );

    viewModel = AnalysisViewModel(repository: repository);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnalysis();
    });
  }

  Future<void> _loadAnalysis() async {
    if (isLoadingCrop) {
      return;
    }

    isLoadingCrop = true;

    final cropCubit = context.read<CropCubit>();

    if (cropCubit.state.crops.isEmpty) {
      await cropCubit.getCrops();
    }

    if (!mounted) {
      return;
    }

    final crops = cropCubit.state.crops;

    if (crops.isEmpty) {
      setState(() {
        hasCrop = false;
      });

      isLoadingCrop = false;
      return;
    }

    final cropId = crops.first.id;

    setState(() {
      hasCrop = true;
    });

    await viewModel.loadAnalysis(cropId);

    isLoadingCrop = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<CropCubit, CropState>(
      listener: (context, state) {
        if (state.crops.isNotEmpty && !hasCrop) {
          _loadAnalysis();
        }

        if (state.crops.isEmpty && hasCrop) {
          setState(() {
            hasCrop = false;
          });
        }
      },
      child: AnimatedBuilder(
        animation: viewModel,
        builder: (context, child) {
          if (!hasCrop) {
            return const SizedBox.shrink();
          }

          if (viewModel.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            );
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }

          if (viewModel.sensors.isEmpty) {
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: AnalysisHeader()),
                  const SizedBox(height: 26),
                  const LiveStatusCard(),
                  const SizedBox(height: 16),
                  SensorsStatusCard(
                    allSensorsOnline: viewModel.allSensorsOnline,
                    lastUpdated: viewModel.lastUpdated,
                  ),

                  const SizedBox(height: 16),

                  ...viewModel.sensors.map(
                    (sensor) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SensorCard(sensor: sensor),
                    ),
                  ),

                  const SizedBox(height: 4),

                  EnvironmentTrendsCard(trends: viewModel.environmentTrends),
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
