import 'package:dio/dio.dart';
import 'package:hydronex_app/features/aibot/data/models/ai_response_model.dart';
import 'package:hydronex_app/features/aibot/data/models/chat_request.dart';

class AiBotRemoteDataSource {
  final Dio dio;

  AiBotRemoteDataSource({required this.dio});

  Future<AiResponseModel> sendMessage(ChatRequest request) async {
    final response = await dio.post('/api/chat', data: request.toJson());

    return AiResponseModel(message: response.data['reply']);
  }
}
