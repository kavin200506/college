class Message {
  final String role;
  final String content;

  const Message(this.role, this.content);

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      json['role'] ?? '',
      json['content'] ?? '',
    );
  }

  @override
  String toString() => 'Message(role: $role, content: $content)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.role == role && other.content == content;
  }

  @override
  int get hashCode => role.hashCode ^ content.hashCode;
}
