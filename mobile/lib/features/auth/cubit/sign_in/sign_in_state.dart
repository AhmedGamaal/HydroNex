part of 'sign_in_cubit.dart';

enum SignInStatus { initial, loading, success, failure }

class SignInState {
  final SignInStatus status;
  final bool rememberMe;
  final String? errorMessage;

  const SignInState({
    this.status = SignInStatus.initial,
    this.rememberMe = false,
    this.errorMessage,
  });

  bool get isLoading => status == SignInStatus.loading;

  SignInState copyWith({
    SignInStatus? status,
    bool? rememberMe,
    String? errorMessage,
  }) {
    return SignInState(
      status: status ?? this.status,
      rememberMe: rememberMe ?? this.rememberMe,
      // errorMessage is intentionally not "?? this.errorMessage" —
      // pass it explicitly (or null) each time so a stale error can't
      // leak into a state that shouldn't have one.
      errorMessage: errorMessage,
    );
  }
}
