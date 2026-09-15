part of 'farm_cubit.dart';

enum FarmStatus { initial, loading, success, failure }

class FarmState {
  final FarmStatus status;
  final List<FarmResponse> farms;
  final String? errorMessage;

  const FarmState({
    this.status = FarmStatus.initial,
    this.farms = const [],
    this.errorMessage,
  });

  bool get isLoading => status == FarmStatus.loading;

  bool get hasFarms => farms.isNotEmpty;

  FarmState copyWith({
    FarmStatus? status,
    List<FarmResponse>? farms,
    String? errorMessage,
  }) {
    return FarmState(
      status: status ?? this.status,
      farms: farms ?? this.farms,
      errorMessage: errorMessage,
    );
  }
}
