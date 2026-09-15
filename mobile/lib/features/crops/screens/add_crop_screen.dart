import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/routes/app_routes.dart';
import 'package:hydronex_app/core/utils/crop_validators.dart';
import 'package:hydronex_app/core/widgets/custom_button.dart';
import 'package:hydronex_app/core/widgets/custom_dropdown.dart';
import 'package:hydronex_app/features/crops/cubit/crop/crop_cubit.dart';
import 'package:hydronex_app/features/crops/data/crop_service.dart';
import 'package:hydronex_app/features/farms/data/farm_service.dart';
import 'package:hydronex_app/features/home/view/widgets/crop_details_section.dart';
import 'package:hydronex_app/features/sensors/cubit/sensor/sensor_service.dart';

class AddCropScreen extends StatefulWidget {
  static const String routeName = AppRoutes.addCrop;

  const AddCropScreen({super.key});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final TextEditingController batchIdController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String? selectedCrop;
  String? cropTypeError;
  String? batchIdError;
  String? locationError;

  final farmRepository = FarmService.createRepository();

  Future<void> registerCrop(BuildContext cubitContext) async {
    setState(() {
      cropTypeError = CropValidators.cropType(selectedCrop);
      batchIdError = CropValidators.batchId(batchIdController.text);
      locationError = CropValidators.location(locationController.text);
    });

    if (cropTypeError != null ||
        batchIdError != null ||
        locationError != null) {
      return;
    }

    try {
      final farms = await farmRepository.getFarms();

      if (farms.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No farm found. Please create a farm first.'),
          ),
        );

        return;
      }

      final crops = await cubitContext.read<CropCubit>().getCrops();

      if (crops.isNotEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You already have a crop registered.')),
        );

        return;
      }

      final farmId = farms.first.id;

      final crop = await cubitContext.read<CropCubit>().createCrop(
        farmId: farmId,
        cropType: selectedCrop!,
        batchId: batchIdController.text.trim(),
        location: locationController.text.trim(),
        notes: noteController.text.trim(),
        variety: '',
        plantingDate: DateTime.now().toUtc().toIso8601String(),
        cycleDuration: 21,
      );

      if (crop == null) {
        return;
      }

      final sensorCubit = SensorCubitService.create();

      await sensorCubit.createDefaultSensors(crop.id);

      await sensorCubit.close();

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    batchIdController.dispose();
    locationController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CropCubit(repository: CropService.createRepository()),
      child: BlocListener<CropCubit, CropState>(
        listener: (context, state) {
          if (state.status == CropStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to register crop.'),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Add New Crop')),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomDropdown(
                    hintText: 'Choose your Crop',
                    items: const [
                      'Lettuce',
                      'Basil',
                      'Cucumber',
                      'Tomato',
                      'Strawberry',
                    ],
                    errorText: cropTypeError,
                    onChanged: (value) {
                      setState(() {
                        selectedCrop = value;
                        cropTypeError = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CropDetailsSection(
                    batchIdController: batchIdController,
                    locationController: locationController,
                    noteController: noteController,
                    batchIdError: batchIdError,
                    locationError: locationError,
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<CropCubit, CropState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: state.isLoading
                            ? 'Registering...'
                            : 'Register Crop',
                        onPressed: state.isLoading
                            ? null
                            : () => registerCrop(context),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
