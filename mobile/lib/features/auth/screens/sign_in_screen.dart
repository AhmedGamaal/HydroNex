import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/errors/api_error_handler.dart';
import 'package:hydronex_app/core/routes/app_routes.dart';
import 'package:hydronex_app/core/routes/route_context_extention.dart';
import 'package:hydronex_app/core/widgets/custom_button.dart';
import 'package:hydronex_app/features/auth/domain/auth_repository.dart';
import 'package:hydronex_app/features/farms/data/farm_service.dart';
import 'package:hydronex_app/features/farms/domain/farm_repository.dart';
import '../cubit/sign_in/sign_in_cubit.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_form_layout.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_text_link.dart';
import '../widgets/remember_me_switch.dart';
import 'sign_up_screen.dart';
import '../data/auth_service.dart';

class SignInScreen extends StatelessWidget {
  static const String routeName = AppRoutes.signIn;

  final AuthRepository? repository;
  final FarmRepository? farmRepository;
  final VoidCallback? onSignedIn;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onCreateAccount;

  const SignInScreen({
    super.key,
    this.repository,
    this.farmRepository,
    this.onSignedIn,
    this.onForgotPassword,
    this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    final authRepository = repository ?? AuthService.createRepository();
    final farmRepo = farmRepository ?? FarmService.createRepository();

    return BlocProvider(
      create: (_) => SignInCubit(repository: authRepository),
      child: _SignInView(
        farmRepository: farmRepo,
        onSignedIn: onSignedIn,
        onForgotPassword: onForgotPassword,
        onCreateAccount: onCreateAccount,
      ),
    );
  }
}

class _SignInView extends StatefulWidget {
  final FarmRepository farmRepository;
  final VoidCallback? onSignedIn;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onCreateAccount;

  const _SignInView({
    required this.farmRepository,
    this.onSignedIn,
    this.onForgotPassword,
    this.onCreateAccount,
  });

  @override
  State<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignInView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<SignInCubit>().signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _goToForgotPassword() {
    if (widget.onForgotPassword != null) {
      widget.onForgotPassword!();
      return;
    }

    context.pushNamed(AppRoutes.forgotPassword);
  }

  void _goToSignUp() {
    if (widget.onCreateAccount != null) {
      widget.onCreateAccount!();
      return;
    }

    Navigator.of(context).pushNamed(SignUpScreen.routeName);
  }

  Future<void> _handleSuccessfulLogin() async {
    try {
      final farms = await widget.farmRepository.getFarms();

      if (!mounted) return;

      if (farms.isNotEmpty) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      } else {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.farmSetup, (route) => false);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ApiErrorHandler.getMessage(e))),
      );
    }
  }

  void _handleStatusChange(BuildContext context, SignInState state) {
    if (state.status == SignInStatus.failure && state.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    } else if (state.status == SignInStatus.success) {
      context.read<SignInCubit>().acknowledge();

      if (widget.onSignedIn != null) {
        widget.onSignedIn!();
        return;
      }

      _handleSuccessfulLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: _handleStatusChange,
      builder: (context, state) {
        return AuthScaffold(
          body: AuthFormLayout(
            formKey: _formKey,
            footer: AuthFooterLink(
              question: "Don't have account?",
              actionText: 'Sign Up',
              onTap: _goToSignUp,
            ),
            children: [
              const AuthHeader(
                title: 'Welcome Back !',
                subtitle: 'Login to your account',
              ),
              const SizedBox(height: 40),
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
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RememberMeSwitch(
                    value: state.rememberMe,
                    onChanged: (v) =>
                        context.read<SignInCubit>().toggleRememberMe(v),
                  ),
                  AuthTextLink(
                    text: 'Forget password?',
                    onTap: _goToForgotPassword,
                  ),
                ],
              ),
              const SizedBox(height: 34),
              CustomButton(
                text: 'Login',
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
