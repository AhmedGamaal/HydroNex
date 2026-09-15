class ChatRequest {
  final int cropId;
  final String message;

  const ChatRequest({required this.cropId, required this.message});

  Map<String, dynamic> toJson() {
    return {'cropId': cropId, 'message': message};
  }
}
