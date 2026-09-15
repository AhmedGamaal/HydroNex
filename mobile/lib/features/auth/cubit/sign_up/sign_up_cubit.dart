import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/errors/api_error_handler.dart';
import 'package:hydronex_app/features/auth/data/models/register_request.dart';
import 'package:hydronex_app/features/auth/domain/auth_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({AuthRepository? repository})
    : _repository = repository,
      super(const SignUpState());

  final AuthRepository? _repository;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: SignUpStatus.loading, errorMessage: null));

    try {
      if (_repository != null) {
        await _repository.signUp(
          RegisterRequest(
            fullName: name,
            email: email,
            password: password,
            confirmPassword: password,
          ),
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 600));
      }

      emit(state.copyWith(status: SignUpStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: ApiErrorHandler.getMessage(e),
        ),
      );
    }
  }

  void acknowledge() {
    if (state.status != SignUpStatus.initial) {
      emit(state.copyWith(status: SignUpStatus.initial));
    }
  }
}
