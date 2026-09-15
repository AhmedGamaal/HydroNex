import 'package:hydronex_app/features/aibot/data/datasources/ai_bot_remote_data_source.dart';
import 'package:hydronex_app/features/aibot/data/models/ai_response_model.dart';
import 'package:hydronex_app/features/aibot/data/models/chat_request.dart';
import 'package:hydronex_app/features/aibot/data/repositories/ai_bot_repository.dart';

class AiBotRepositoryImpl implements AiBotRepository {
  final AiBotRemoteDataSource remoteDataSource;

  AiBotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AiResponseModel> sendMessage(ChatRequest request) {
    return remoteDataSource.sendMessage(request);
  }
}
