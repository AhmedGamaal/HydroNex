part of 'otp_cubit.dart';

enum OtpStatus { initial, loading, success, failure }

class OtpState {
  final OtpStatus status;
  final String code;
  final int secondsLeft;
  final String? errorMessage;

  const OtpState({
    this.status = OtpStatus.initial,
    this.code = '',
    this.secondsLeft = 30,
    this.errorMessage,
  });

  bool get isLoading => status == OtpStatus.loading;
  bool get canResend => secondsLeft == 0;

  OtpState copyWith({
    OtpStatus? status,
    String? code,
    int? secondsLeft,
    String? errorMessage,
  }) {
    return OtpState(
      status: status ?? this.status,
      code: code ?? this.code,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      errorMessage: errorMessage,
    );
  }
}
