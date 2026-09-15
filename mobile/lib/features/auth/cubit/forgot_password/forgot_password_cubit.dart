import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/errors/api_error_handler.dart';
import 'package:hydronex_app/features/auth/data/models/forgot_password_request.dart';
import 'package:hydronex_app/features/auth/domain/auth_repository.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({AuthRepository? repository})
    : _repository = repository,
      super(const ForgotPasswordState());

  final AuthRepository? _repository;

  Future<void> sendOtp(String email) async {
    emit(
      state.copyWith(status: ForgotPasswordStatus.loading, errorMessage: null),
    );

    try {
      if (_repository != null) {
        await _repository.sendOtp(ForgotPasswordRequest(email: email));
      } else {
        await Future.delayed(const Duration(milliseconds: 600));
      }

      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: ApiErrorHandler.getMessage(e),
        ),
      );
    }
  }

  void acknowledge() {
    if (state.status != ForgotPasswordStatus.initial) {
      emit(state.copyWith(status: ForgotPasswordStatus.initial));
    }
  }
}
