import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/features/home/data/models/crop_model.dart';
import 'package:hydronex_app/features/home/view/screens/alerts_screen.dart';
import 'package:hydronex_app/features/splash/screens/splash_screen.dart';
import '../../features/auth/screens/set_new_password_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/reset_success_screen.dart';
import '../../features/aibot/view/screens/ai_bot_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/sign_in_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/crops/screens/add_crop_screen.dart';
import '../../features/alerts/cubit/alert/alert_cubit.dart';
import '../../features/home/view/screens/crop_info_screen.dart';
import '../../features/home/view/screens/home_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/plant_vision/view/screens/camera_screen.dart';
import '../../features/profile/view/screens/help_support_screen.dart';
import '../../features/farms/screens/farm_setup_screen.dart';
import '../../features/alerts/cubit/alert/alert_service.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return slideUpRoute(OnboardingScreen());

      case AppRoutes.splash:
        return slideUpRoute(SplashScreen());

      case AppRoutes.home:
        return slideUpRoute(HomeScreen());

      case AppRoutes.addCrop:
        return slideUpRoute(AddCropScreen());

      case AppRoutes.cropInfo:
        final crop = settings.arguments as CropModel;
        return slideUpRoute(CropInfoScreen(crop: crop));

      case AppRoutes.alerts:
        final args = settings.arguments as Map<String, dynamic>;

        return slideUpRoute(
          BlocProvider<AlertCubit>(
            create: (_) => AlertCubitService.create(),
            child: AlertsScreen(cropId: args['cropId'] as int),
          ),
        );

      case AppRoutes.helpSupport:
        return slideUpRoute(HelpSupportScreen());

      case AppRoutes.aiBot:
        return slideUpRoute(AiBotScreen());

      case AppRoutes.camera:
        final args = settings.arguments as Map<String, dynamic>;

        return slideUpRoute(CameraScreen(cropId: args['cropId'] as int));

      case AppRoutes.forgotPassword:
        return slideUpRoute(ForgotPasswordScreen());

      case AppRoutes.signIn:
        return slideUpRoute(SignInScreen());

      case AppRoutes.signUp:
        return slideUpRoute(SignUpScreen());

      case AppRoutes.otpVerification:
        final args = settings.arguments as Map<String, dynamic>;

        return slideUpRoute(
          OtpVerificationScreen(
            email: args['email'] as String,
            isPasswordResetFlow: args['isPasswordResetFlow'] as bool,
          ),
        );

      case AppRoutes.setNewPassword:
        final args = settings.arguments as Map<String, dynamic>;

        return slideUpRoute(
          SetNewPasswordScreen(
            email: args['email'] as String,
            code: args['code'] as String,
          ),
        );

      case AppRoutes.resetSuccess:
        return slideUpRoute(ResetSuccessScreen());

      case AppRoutes.farmSetup:
        return slideUpRoute(const FarmSetupScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static PageRouteBuilder slideUpRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset(0.0, 0.0);
        const curve = Curves.easeInOut;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }
}
