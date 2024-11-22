class Task {
  final String description;
  final String category;
  final String priority;
  final DateTime? dueDate;
  bool isCompleted;
  bool isArchived;

  Task({
    required this.description,
    required this.category,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
    this.isArchived = false,
  });
}
