import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';
import 'package:hydronex_app/core/constants/app_text_styles.dart';
import 'package:hydronex_app/core/routes/app_routes.dart';
import 'package:hydronex_app/core/widgets/custom_button.dart';
import 'package:hydronex_app/features/auth/widgets/auth_scaffold.dart';
import 'package:hydronex_app/features/auth/widgets/auth_text_field.dart';
import 'package:hydronex_app/features/farms/cubit/farm/farm_cubit.dart';
import 'package:hydronex_app/features/farms/data/farm_service.dart';

class FarmSetupScreen extends StatelessWidget {
  static const String routeName = AppRoutes.farmSetup;

  const FarmSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FarmCubit(repository: FarmService.createRepository()),
      child: const _FarmSetupView(),
    );
  }
}

class _FarmSetupView extends StatefulWidget {
  const _FarmSetupView();

  @override
  State<_FarmSetupView> createState() => _FarmSetupViewState();
}

class _FarmSetupViewState extends State<_FarmSetupView> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createFarm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<FarmCubit>().createFarm(
      name: _nameController.text.trim(),
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AuthScaffold(
        showBackButton: false,
        body: BlocListener<FarmCubit, FarmState>(
          listener: (context, state) {
            if (state.status == FarmStatus.success && state.farms.isNotEmpty) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
            }

            if (state.status == FarmStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 25),

                  Text(
                    'HydroNex',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.authTitle.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Farm Setup',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.authTitle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Enter your farm information to get started.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.authSubtitle,
                  ),

                  const SizedBox(height: 32),

                  AuthTextField(
                    controller: _nameController,
                    hintText: 'Farm Name',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter farm name';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  AuthTextField(
                    controller: _locationController,
                    hintText: 'Location',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter farm location';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    maxLength: 200,
                    textInputAction: TextInputAction.newline,
                    style: AppTextStyles.authInputText,
                    cursorColor: AppColors.primaryDark,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      hintStyle: AppTextStyles.authInputHint,
                      counterStyle: AppTextStyles.authInputHint,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.inputBorder,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  BlocBuilder<FarmCubit, FarmState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Create Farm',
                        isLoading: state.isLoading,
                        onPressed: _createFarm,
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
