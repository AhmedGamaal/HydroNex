import 'package:flutter/foundation.dart';
import 'package:hydronex_app/features/aibot/data/models/ai_response_model.dart';
import 'package:hydronex_app/features/aibot/data/models/chat_message_model.dart';
import 'package:hydronex_app/features/aibot/data/models/chat_request.dart';
import 'package:hydronex_app/features/aibot/data/repositories/ai_bot_repository.dart';

class AiBotViewModel extends ChangeNotifier {
  AiBotRepository repository;

  List<ChatMessageModel> messages = [];

  bool isLoading = false;
  String? errorMessage;

  AiBotViewModel({required this.repository});

  Future<void> sendMessage({
    required int cropId,
    required String message,
  }) async {
    if (message.trim().isEmpty || isLoading) {
      return;
    }

    errorMessage = null;

    messages.add(ChatMessageModel(message: message, sender: 'user'));

    isLoading = true;
    notifyListeners();

    try {
      AiResponseModel response = await repository.sendMessage(
        ChatRequest(cropId: cropId, message: message),
      );

      messages.add(ChatMessageModel(message: response.message, sender: 'ai'));
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
