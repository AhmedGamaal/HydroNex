part of 'crop_cubit.dart';

enum CropStatus { initial, loading, success, deleteSuccess, failure }

class CropState {
  final CropStatus status;
  final List<CropResponse> crops;
  final String? errorMessage;

  const CropState({
    this.status = CropStatus.initial,
    this.crops = const [],
    this.errorMessage,
  });

  bool get isLoading => status == CropStatus.loading;

  bool get hasCrops => crops.isNotEmpty;

  CropState copyWith({
    CropStatus? status,
    List<CropResponse>? crops,
    String? errorMessage,
  }) {
    return CropState(
      status: status ?? this.status,
      crops: crops ?? this.crops,
      errorMessage: errorMessage,
    );
  }
}
