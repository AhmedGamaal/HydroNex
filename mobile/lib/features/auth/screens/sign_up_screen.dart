import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/widgets/custom_button.dart';
import 'package:hydronex_app/features/auth/data/auth_service.dart';
import 'package:hydronex_app/features/auth/domain/auth_repository.dart';
import '../../../core/routes/app_routes.dart';
import '../cubit/sign_up/sign_up_cubit.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_form_layout.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import 'otp_verification_screen.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = AppRoutes.signUp;

  final AuthRepository? repository;
  final VoidCallback? onSignedUp;
  final VoidCallback? onSignIn;

  const SignUpScreen({
    super.key,
    this.repository,
    this.onSignedUp,
    this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final authRepository = repository ?? AuthService.createRepository();

    return BlocProvider(
      create: (_) => SignUpCubit(repository: authRepository),
      child: _SignUpView(
        onSignedUp: onSignedUp,
        onSignIn: onSignIn,
      ),
    );
  }
}

class _SignUpView extends StatefulWidget {
  final VoidCallback? onSignedUp;
  final VoidCallback? onSignIn;

  const _SignUpView({
    this.onSignedUp,
    this.onSignIn,
  });

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<SignUpCubit>().signUp(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _goToSignIn() {
    if (widget.onSignIn != null) {
      widget.onSignIn!();
      return;
    }

    Navigator.of(context).pop();
  }

  void _handleStatusChange(BuildContext context, SignUpState state) {
    if (state.status == SignUpStatus.failure && state.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    } else if (state.status == SignUpStatus.success) {
      context.read<SignUpCubit>().acknowledge();

      if (widget.onSignedUp != null) {
        widget.onSignedUp!();
      } else {
        Navigator.of(context).pushNamed(
          OtpVerificationScreen.routeName,
          arguments: {
            'email': _emailController.text.trim(),
            'isPasswordResetFlow': false,
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: _handleStatusChange,
      builder: (context, state) {
        return AuthScaffold(
          body: AuthFormLayout(
            formKey: _formKey,
            footer: AuthFooterLink(
              question: 'Already have an account?',
              actionText: 'Sign In',
              onTap: _goToSignIn,
            ),
            children: [
              const AuthHeader(
                title: 'Welcome',
                subtitle: 'Create your new account',
              ),
              const SizedBox(height: 40),
              AuthTextField(
                controller: _nameController,
                hintText: 'Name',
                validator: AuthValidators.name,
              ),
              const SizedBox(height: 24),
              AuthTextField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: AuthValidators.email,
              ),
              const SizedBox(height: 24),
              AuthPasswordField(
                controller: _passwordController,
                validator: AuthValidators.password,
              ),
              const SizedBox(height: 24),
              AuthPasswordField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    AuthValidators.confirmPassword(v, _passwordController.text),
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Get Started',
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
