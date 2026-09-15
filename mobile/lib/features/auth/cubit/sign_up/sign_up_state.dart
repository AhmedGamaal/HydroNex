part of 'sign_up_cubit.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState {
  final SignUpStatus status;
  final String? errorMessage;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == SignUpStatus.loading;

  SignUpState copyWith({
    SignUpStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
