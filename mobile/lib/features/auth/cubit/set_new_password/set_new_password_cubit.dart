import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/errors/api_error_handler.dart';
import 'package:hydronex_app/features/auth/data/models/reset_password_request.dart';
import 'package:hydronex_app/features/auth/domain/auth_repository.dart';

part 'set_new_password_state.dart';

class SetNewPasswordCubit extends Cubit<SetNewPasswordState> {
  SetNewPasswordCubit({AuthRepository? repository, this.email, this.code})
    : _repository = repository,
      super(const SetNewPasswordState());

  final AuthRepository? _repository;
  final String? email;
  final String? code;

  Future<void> confirm(String password) async {
    emit(
      state.copyWith(status: SetNewPasswordStatus.loading, errorMessage: null),
    );

    try {
      if (_repository != null) {
        await _repository.resetPassword(
          ResetPasswordRequest(
            email: email!,
            code: code!,
            newPassword: password,
            confirmPassword: password,
          ),
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 600));
      }

      emit(state.copyWith(status: SetNewPasswordStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: SetNewPasswordStatus.failure,
          errorMessage: ApiErrorHandler.getMessage(e),
        ),
      );
    }
  }

  void acknowledge() {
    if (state.status != SetNewPasswordStatus.initial) {
      emit(state.copyWith(status: SetNewPasswordStatus.initial));
    }
  }
}
