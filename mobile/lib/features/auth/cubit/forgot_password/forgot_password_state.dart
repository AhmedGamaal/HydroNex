part of 'forgot_password_cubit.dart';

enum ForgotPasswordStatus {
  initial,
  loading,
  success,
  failure,
}

class ForgotPasswordState {
  final ForgotPasswordStatus status;
  final String? errorMessage;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == ForgotPasswordStatus.loading;

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
