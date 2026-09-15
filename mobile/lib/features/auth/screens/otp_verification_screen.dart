import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';
import 'package:hydronex_app/core/constants/app_text_styles.dart';
import 'package:hydronex_app/core/widgets/custom_button.dart';
import 'package:hydronex_app/features/auth/data/auth_service.dart';
import 'package:hydronex_app/features/home/view/screens/home_screen.dart';
import 'package:hydronex_app/core/routes/app_routes.dart';
import '../cubit/otp/otp_cubit.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/otp_box_input.dart';
import '../widgets/otp_resend_link.dart';
import 'set_new_password_screen.dart';

class OtpVerificationScreen extends StatelessWidget {
  static const String routeName = AppRoutes.otpVerification;

  final String email;
  final int codeLength;
  final VoidCallback? onVerified;
  final bool isPasswordResetFlow;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.codeLength = 6,
    this.onVerified,
    this.isPasswordResetFlow = false,
  });

  @override
  Widget build(BuildContext context) {
        return BlocProvider(
      create: (_) => OtpCubit(
        repository: AuthService.createRepository(),
        codeLength: codeLength,
        email: email,
        isPasswordResetFlow: isPasswordResetFlow,
      ),
    // return BlocProvider(
    //   create: (_) => OtpCubit(
    //     repository: AuthService.createRepository(),
    //     codeLength: codeLength,
    //     email: email,
    //   ),
      child: _OtpView(
        email: email,
        codeLength: codeLength,
        onVerified: onVerified,
        isPasswordResetFlow: isPasswordResetFlow,
      ),
    );
  }
}

class _OtpView extends StatefulWidget {
  final String email;
  final bool isPasswordResetFlow;
  final int codeLength;
  final VoidCallback? onVerified;

  const _OtpView({
    required this.email,
    required this.codeLength,
    this.onVerified,
    required this.isPasswordResetFlow,
  });

  @override
  State<_OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<_OtpView> {
  final _otpKey = GlobalKey<OtpBoxInputState>();

  void _handleStatusChange(BuildContext context, OtpState state) {
    if (state.status == OtpStatus.failure && state.errorMessage != null) {
      _otpKey.currentState?.clear();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    } else if (state.errorMessage != null &&
        state.status == OtpStatus.initial) {
      // Local validation error (e.g. "enter the full code").
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    } else if (state.status == OtpStatus.success) {
      context.read<OtpCubit>().acknowledge();

      if (widget.onVerified != null) {
        widget.onVerified!();
      } else if (widget.isPasswordResetFlow) {
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.setNewPassword,
          arguments: {'email': widget.email, 'code': state.code},
        );
      } else {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.farmSetup, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpState>(
      listener: _handleStatusChange,
      builder: (context, state) {
        return AuthScaffold(
          showBackButton: true,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 52),
                AuthHeader(
                  showLogo: false,
                  title: 'OTP Verification',
                  titleStyle: AppTextStyles.headingSemibold24,
                  subtitle:
                      'Enter the verification code we just sent to your email ${widget.email}.',
                  subtitleStyle: AppTextStyles.bodyPrimaryDark16,
                  subtitleGap: 10,
                ),
                const SizedBox(height: 40),
                OtpBoxInput(
                  key: _otpKey,
                  length: widget.codeLength,
                  onChanged: (code) =>
                      context.read<OtpCubit>().codeChanged(code),
                  onCompleted: (code) =>
                      context.read<OtpCubit>().codeChanged(code),
                ),
                const SizedBox(height: 24),
                OtpResendLink(
                  secondsLeft: state.secondsLeft,
                  onResend: () => context.read<OtpCubit>().resend(),
                ),
                const SizedBox(height: 64),
                CustomButton(
                  text: 'Verify',
                  isLoading: state.isLoading,
                  backgroundColor: state.code.length == widget.codeLength
                      ? null
                      : AppColors.buttonInactiveBg,
                  foregroundColor: state.code.length == widget.codeLength
                      ? null
                      : AppColors.textMuted,
                  onPressed: () => context.read<OtpCubit>().verify(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
