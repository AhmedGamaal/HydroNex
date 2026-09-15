// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hydronex_app/core/errors/api_error_handler.dart';
// import 'package:hydronex_app/features/auth/data/models/forgot_password_request.dart';
// import 'package:hydronex_app/features/auth/data/models/verify_otp_request.dart';
// import 'package:hydronex_app/features/auth/domain/auth_repository.dart';

// part 'otp_state.dart';

// class OtpCubit extends Cubit<OtpState> {
//   OtpCubit({
//     AuthRepository? repository,
//     this.codeLength = 6,
//     this.cooldownSeconds = 30,
//     this.email,
//   }) : _repository = repository,
//        super(OtpState(secondsLeft: cooldownSeconds)) {
//     _startCooldown();
//   }

//   final AuthRepository? _repository;
//   final int codeLength;
//   final int cooldownSeconds;
//   final String? email;
//   Timer? _timer;

//   void codeChanged(String code) {
//     emit(state.copyWith(code: code));
//   }

//   void _startCooldown() {
//     _timer?.cancel();
//     emit(state.copyWith(secondsLeft: cooldownSeconds));

//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (state.secondsLeft <= 1) {
//         t.cancel();
//         emit(state.copyWith(secondsLeft: 0));
//       } else {
//         emit(state.copyWith(secondsLeft: state.secondsLeft - 1));
//       }
//     });
//   }

//   Future<void> resend() async {
//     if (state.secondsLeft > 0) return;

//     if (email == null || email!.isEmpty) {
//       emit(state.copyWith(errorMessage: 'Email is required'));
//       return;
//     }

//     try {
//       if (_repository != null) {
//         await _repository.sendOtp(ForgotPasswordRequest(email: email!));
//       } else {
//         await Future.delayed(const Duration(milliseconds: 400));
//       }
//     } catch (e) {
//       emit(state.copyWith(errorMessage: ApiErrorHandler.getMessage(e)));
//     } finally {
//       _startCooldown();
//     }
//   }

//   Future<void> verify() async {
//     if (state.code.length != codeLength) {
//       emit(state.copyWith(errorMessage: 'Please enter the full code'));
//       return;
//     }

//     if (email == null || email!.isEmpty) {
//       emit(state.copyWith(errorMessage: 'Email is required'));
//       return;
//     }

//     emit(state.copyWith(status: OtpStatus.loading, errorMessage: null));

//     try {
//       if (_repository != null) {
//         await _repository.verifyOtp(
//           VerifyOtpRequest(email: email!, code: state.code),
//         );
//       } else {
//         await Future.delayed(const Duration(milliseconds: 600));
//       }

//       emit(state.copyWith(status: OtpStatus.success));
//     } catch (e) {
//       emit(
//         state.copyWith(
//           status: OtpStatus.failure,
//           errorMessage: ApiErrorHandler.getMessage(e),
//         ),
//       );
//     }
//   }

//   void acknowledge() {
//     if (state.status != OtpStatus.initial) {
//       emit(state.copyWith(status: OtpStatus.initial));
//     }
//   }

//   @override
//   Future<void> close() {
//     _timer?.cancel();
//     return super.close();
//   }
// }

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/errors/api_error_handler.dart';
import 'package:hydronex_app/features/auth/data/models/forgot_password_request.dart';
import 'package:hydronex_app/features/auth/data/models/verify_otp_request.dart';
import 'package:hydronex_app/features/auth/domain/auth_repository.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit({
    AuthRepository? repository,
    this.codeLength = 6,
    this.cooldownSeconds = 30,
    this.email,
    this.isPasswordResetFlow = false,
  }) : _repository = repository,
       super(OtpState(secondsLeft: cooldownSeconds)) {
    _startCooldown();
  }

  final AuthRepository? _repository;
  final int codeLength;
  final int cooldownSeconds;
  final String? email;
  final bool isPasswordResetFlow;
  Timer? _timer;

  void codeChanged(String code) {
    emit(state.copyWith(code: code));
  }

  void _startCooldown() {
    _timer?.cancel();
    emit(state.copyWith(secondsLeft: cooldownSeconds));

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state.secondsLeft <= 1) {
        t.cancel();
        emit(state.copyWith(secondsLeft: 0));
      } else {
        emit(state.copyWith(secondsLeft: state.secondsLeft - 1));
      }
    });
  }

  Future<void> resend() async {
    if (state.secondsLeft > 0) return;

    if (email == null || email!.isEmpty) {
      emit(state.copyWith(errorMessage: 'Email is required'));
      return;
    }

    try {
      if (_repository != null) {
        await _repository.sendOtp(ForgotPasswordRequest(email: email!));
      } else {
        await Future.delayed(const Duration(milliseconds: 400));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: ApiErrorHandler.getMessage(e)));
    } finally {
      _startCooldown();
    }
  }

  Future<void> verify() async {
    if (state.code.length != codeLength) {
      emit(state.copyWith(errorMessage: 'Please enter the full code'));
      return;
    }

    if (email == null || email!.isEmpty) {
      emit(state.copyWith(errorMessage: 'Email is required'));
      return;
    }

    emit(state.copyWith(status: OtpStatus.loading, errorMessage: null));

    try {
      if (_repository != null ) {
        await _repository.verifyOtp(
          VerifyOtpRequest(email: email!, code: state.code),
        );
      } else if (_repository == null) {
        await Future.delayed(const Duration(milliseconds: 600));
      }

      emit(state.copyWith(status: OtpStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: OtpStatus.failure,
          errorMessage: ApiErrorHandler.getMessage(e),
        ),
      );
    }
  }

  void acknowledge() {
    if (state.status != OtpStatus.initial) {
      emit(state.copyWith(status: OtpStatus.initial));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}