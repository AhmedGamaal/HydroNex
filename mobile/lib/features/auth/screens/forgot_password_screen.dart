import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/widgets/custom_button.dart';
import 'package:hydronex_app/features/auth/data/auth_service.dart';
import 'package:hydronex_app/features/auth/domain/auth_repository.dart';
import 'package:hydronex_app/core/routes/app_routes.dart';
import '../cubit/forgot_password/forgot_password_cubit.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_form_layout.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String routeName = AppRoutes.forgotPassword;

  final AuthRepository? repository;

  const ForgotPasswordScreen({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    final authRepository = repository ?? AuthService.createRepository();

    return BlocProvider(
      create: (_) => ForgotPasswordCubit(repository: authRepository),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ForgotPasswordCubit>().sendOtp(_emailController.text.trim());
  }

  void _handleStatusChange(BuildContext context, ForgotPasswordState state) {
    if (state.status == ForgotPasswordStatus.failure &&
        state.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    } else if (state.status == ForgotPasswordStatus.success) {
      context.read<ForgotPasswordCubit>().acknowledge();

      Navigator.of(context).pushReplacementNamed(
        OtpVerificationScreen.routeName,
        arguments: {
          'email': _emailController.text.trim(),
          'isPasswordResetFlow': true,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: _handleStatusChange,
      builder: (context, state) {
        return AuthScaffold(
          showBackButton: true,
          body: AuthFormLayout(
            formKey: _formKey,
            children: [
              const AuthHeader(
                title: 'Forgot Password',
                subtitle: 'Enter your email to receive a verification code',
              ),
              const SizedBox(height: 40),
              AuthTextField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: AuthValidators.email,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Send Code',
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        );
      },
    );
  }
}
