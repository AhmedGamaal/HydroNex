import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/constants/app_text_styles.dart';
import 'package:hydronex_app/core/widgets/custom_button.dart';
import 'package:hydronex_app/features/auth/domain/auth_repository.dart';
import '../cubit/set_new_password/set_new_password_cubit.dart';
import 'package:hydronex_app/core/routes/app_routes.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_form_layout.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/terms_footer.dart';
import 'reset_success_screen.dart';

class SetNewPasswordScreen extends StatelessWidget {
  static const String routeName = AppRoutes.setNewPassword;

  final String email;
  final String code;
  final AuthRepository? repository;
  final VoidCallback? onConfirmed;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onCookiesTap;

  const SetNewPasswordScreen({
    super.key,
    required this.email,
    required this.code,
    this.repository,
    this.onConfirmed,
    this.onTermsTap,
    this.onPrivacyTap,
    this.onCookiesTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SetNewPasswordCubit(repository: repository, email: email, code: code),
      child: _SetNewPasswordView(
        onConfirmed: onConfirmed,
        onTermsTap: onTermsTap,
        onPrivacyTap: onPrivacyTap,
        onCookiesTap: onCookiesTap,
      ),
    );
  }
}

class _SetNewPasswordView extends StatefulWidget {
  final VoidCallback? onConfirmed;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onCookiesTap;

  const _SetNewPasswordView({
    this.onConfirmed,
    this.onTermsTap,
    this.onPrivacyTap,
    this.onCookiesTap,
  });

  @override
  State<_SetNewPasswordView> createState() => _SetNewPasswordViewState();
}

class _SetNewPasswordViewState extends State<_SetNewPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<SetNewPasswordCubit>().confirm(_passwordController.text);
  }

  void _handleStatusChange(BuildContext context, SetNewPasswordState state) {
    if (state.status == SetNewPasswordStatus.failure &&
        state.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    } else if (state.status == SetNewPasswordStatus.success) {
      context.read<SetNewPasswordCubit>().acknowledge();
      if (widget.onConfirmed != null) {
        widget.onConfirmed!();
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.resetSuccess);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetNewPasswordCubit, SetNewPasswordState>(
      listener: _handleStatusChange,
      builder: (context, state) {
        return AuthScaffold(
          showBackButton: true,
          body: AuthFormLayout(
            formKey: _formKey,
            scrollPadding: const EdgeInsets.symmetric(horizontal: 16),
            footerPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            footer: TermsFooter(
              onTermsTap: widget.onTermsTap,
              onPrivacyTap: widget.onPrivacyTap,
              onCookiesTap: widget.onCookiesTap,
            ),
            children: [
              const AuthHeader(
                title: 'Set New Password',
                titleStyle: AppTextStyles.headingBold24,
                gap: 16,
              ),
              const SizedBox(height: 40),
              AuthPasswordField(
                controller: _passwordController,
                validator: AuthValidators.password,
              ),
              const SizedBox(height: 16),
              AuthPasswordField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    AuthValidators.confirmPassword(v, _passwordController.text),
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Confirm',
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
