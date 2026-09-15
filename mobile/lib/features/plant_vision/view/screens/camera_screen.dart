import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydronex_app/core/network/api_client.dart';
import 'package:hydronex_app/core/storage/token_storage.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/features/plant_vision/data/datasources/plant_vision_remote_data_source.dart';
import 'package:hydronex_app/features/plant_vision/data/repositories/plant_vision_repository_impl.dart';
import 'package:hydronex_app/features/plant_vision/view/screens/plant_vision_result_screen.dart';
import 'package:hydronex_app/features/plant_vision/view/widgets/camera_scanner_overlay.dart';
import 'package:hydronex_app/features/plant_vision/view_model/plant_vision_view_model.dart';

class CameraScreen extends StatefulWidget {
  static const String routeName = '/CameraScreen';

  final int cropId;

  const CameraScreen({super.key, required this.cropId});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? cameraController;

  late PlantVisionViewModel viewModel;

  bool isTakingPicture = false;

  @override
  void initState() {
    super.initState();

    final Dio dio = ApiClient.create(tokenStorage: const TokenStorage());

    final PlantVisionRemoteDataSource remoteDataSource =
        PlantVisionRemoteDataSource(dio: dio);

    final PlantVisionRepositoryImpl repository = PlantVisionRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    viewModel = PlantVisionViewModel(repository: repository);

    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final List<CameraDescription> cameras = await availableCameras();

      if (cameras.isEmpty) {
        debugPrint('No cameras available.');
        return;
      }

      final CameraDescription camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();

      if (!mounted) {
        return;
      }

      setState(() {});
    } on CameraException catch (e) {
      debugPrint('Camera initialization error: ${e.code}');
      debugPrint('Description: ${e.description}');
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> takePicture() async {
    if (cameraController == null ||
        !cameraController!.value.isInitialized ||
        cameraController!.value.isTakingPicture ||
        isTakingPicture) {
      return;
    }

    setState(() {
      isTakingPicture = true;
    });

    try {
      debugPrint('Starting picture capture...');

      final XFile image = await cameraController!.takePicture();

      debugPrint('Picture captured successfully!');
      debugPrint('Image path: ${image.path}');
      debugPrint('Crop ID: ${widget.cropId}');

      await viewModel.analyzePlant(
        imagePath: image.path,
        cropId: widget.cropId,
      );

      if (!mounted) {
        return;
      }

      if (viewModel.analysis != null) {
        debugPrint('Plant analysis completed successfully!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PlantVisionResultScreen(
              analysis: viewModel.analysis!,
              imagePath: image.path,
            ),
          ),
        );
      } else if (viewModel.errorMessage != null) {
        debugPrint('Plant analysis error: ${viewModel.errorMessage}');

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(viewModel.errorMessage!)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plant analysis failed. Please try again.'),
          ),
        );
      }
    } on CameraException catch (e) {
      debugPrint('Camera Error: ${e.code}');
      debugPrint('Camera Description: ${e.description}');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera error: ${e.description ?? e.code}')),
      );
    } on DioException catch (e) {
      debugPrint('API Error: ${e.type}');
      debugPrint('API Status Code: ${e.response?.statusCode}');
      debugPrint('API Response: ${e.response?.data}');

      if (!mounted) {
        return;
      }

      String message = 'Failed to analyze plant.';

      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;

        if (data['message'] != null) {
          message = data['message'].toString();
        } else if (data['title'] != null) {
          message = data['title'].toString();
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      debugPrint('Error analyzing plant: $e');

      if (!mounted) {
        return;
      }

      final String message =
          viewModel.errorMessage ??
          'Failed to analyze plant. Please try again.';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          isTakingPicture = false;
        });
      }
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    final Size previewSize = cameraController!.value.previewSize!;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: previewSize.height,
                height: previewSize.width,
                child: CameraPreview(cameraController!),
              ),
            ),
          ),
          Center(child: CameraScannerOverlay()),
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: isTakingPicture ? null : takePicture,
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.cream,
                  ),
                  child: Center(
                    child: isTakingPicture
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppTheme.primary,
                            ),
                          )
                        : SvgPicture.asset(
                            'assets/icons/camera.svg',
                            width: 32,
                            height: 32,
                            colorFilter: const ColorFilter.mode(
                              AppTheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
