part of 'set_new_password_cubit.dart';

enum SetNewPasswordStatus { initial, loading, success, failure }

class SetNewPasswordState {
  final SetNewPasswordStatus status;
  final String? errorMessage;

  const SetNewPasswordState({
    this.status = SetNewPasswordStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == SetNewPasswordStatus.loading;

  SetNewPasswordState copyWith({
    SetNewPasswordStatus? status,
    String? errorMessage,
  }) {
    return SetNewPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
