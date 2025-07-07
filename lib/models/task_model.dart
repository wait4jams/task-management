class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory Task.fromJson(String id, Map<String, dynamic> json) {
    return Task(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }
}
