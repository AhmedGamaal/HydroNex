import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydronex_app/core/errors/api_error_handler.dart';
import 'package:hydronex_app/features/auth/data/models/login_request.dart';
import 'package:hydronex_app/features/auth/domain/auth_repository.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({AuthRepository? repository})
    : _repository = repository,
      super(const SignInState());

  final AuthRepository? _repository;

  void toggleRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: SignInStatus.loading, errorMessage: null));

    try {
      if (_repository != null) {
        await _repository.signIn(
          LoginRequest(email: email, password: password),
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 600));
      }

      emit(state.copyWith(status: SignInStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: ApiErrorHandler.getMessage(e),
        ),
      );
    }
  }

  void acknowledge() {
    if (state.status != SignInStatus.initial) {
      emit(state.copyWith(status: SignInStatus.initial));
    }
  }
}
