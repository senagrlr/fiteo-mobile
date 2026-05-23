class AiChatMessage {
  final String? id;
  final String role;
  final String text;

  const AiChatMessage({
    this.id,
    required this.role,
    required this.text,
  });

  factory AiChatMessage.fromJson({
    required String id,
    required Map<String, dynamic> json,
  }) {
    return AiChatMessage(
      id: id,
      role: json['role'] as String? ?? 'user',
      text: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'message': text,
    };
  }
}