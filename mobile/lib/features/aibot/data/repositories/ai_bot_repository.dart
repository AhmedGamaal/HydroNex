import 'package:hydronex_app/features/aibot/data/models/ai_response_model.dart';
import 'package:hydronex_app/features/aibot/data/models/chat_request.dart';

abstract class AiBotRepository {
  Future<AiResponseModel> sendMessage(ChatRequest request);
}
