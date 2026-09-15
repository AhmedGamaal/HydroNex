part of 'alert_cubit.dart';

enum AlertStatus { initial, loading, success, failure }

class AlertState {
  final AlertStatus status;
  final List<AlertResponse> alerts;
  final String? errorMessage;

  const AlertState({
    this.status = AlertStatus.initial,
    this.alerts = const [],
    this.errorMessage,
  });

  AlertState copyWith({
    AlertStatus? status,
    List<AlertResponse>? alerts,
    String? errorMessage,
  }) {
    return AlertState(
      status: status ?? this.status,
      alerts: alerts ?? this.alerts,
      errorMessage: errorMessage,
    );
  }
}
