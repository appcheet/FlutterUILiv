import 'package:equatable/equatable.dart';

/// Todo entity representing the core business logic model
class TodoEntity extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final TodoPriority priority;
  final String? category;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TodoEntity({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = TodoPriority.medium,
    this.category,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy with updated fields
  TodoEntity copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    TodoPriority? priority,
    String? category,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Mark todo as completed
  TodoEntity markCompleted() {
    return copyWith(
      isCompleted: true,
      updatedAt: DateTime.now(),
    );
  }

  /// Mark todo as incomplete
  TodoEntity markIncomplete() {
    return copyWith(
      isCompleted: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Toggle completion status
  TodoEntity toggleCompletion() {
    return copyWith(
      isCompleted: !isCompleted,
      updatedAt: DateTime.now(),
    );
  }

  /// Check if todo is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Check if todo is due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final due = dueDate!;
    return now.year == due.year &&
           now.month == due.month &&
           now.day == due.day;
  }

  /// Check if todo is due within next 7 days
  bool get isDueSoon {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    return dueDate!.isBefore(nextWeek) && dueDate!.isAfter(now);
  }

  /// Get priority color
  String get priorityColor {
    switch (priority) {
      case TodoPriority.low:
        return '#4CAF50'; // Green
      case TodoPriority.medium:
        return '#FF9800'; // Orange
      case TodoPriority.high:
        return '#F44336'; // Red
      case TodoPriority.urgent:
        return '#9C27B0'; // Purple
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        priority,
        category,
        dueDate,
        createdAt,
        updatedAt,
      ];
}

/// Todo priority enumeration
enum TodoPriority {
  low,
  medium,
  high,
  urgent;

  /// Get priority label
  String get label {
    switch (this) {
      case TodoPriority.low:
        return 'Low';
      case TodoPriority.medium:
        return 'Medium';
      case TodoPriority.high:
        return 'High';
      case TodoPriority.urgent:
        return 'Urgent';
    }
  }

  /// Get priority value for database storage
  int get value {
    switch (this) {
      case TodoPriority.low:
        return 0;
      case TodoPriority.medium:
        return 1;
      case TodoPriority.high:
        return 2;
      case TodoPriority.urgent:
        return 3;
    }
  }

  /// Create priority from value
  static TodoPriority fromValue(int value) {
    switch (value) {
      case 0:
        return TodoPriority.low;
      case 1:
        return TodoPriority.medium;
      case 2:
        return TodoPriority.high;
      case 3:
        return TodoPriority.urgent;
      default:
        return TodoPriority.medium;
    }
  }
}

/// Todo category entity
class CategoryEntity extends Equatable {
  final int? id;
  final String name;
  final String color;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryEntity({
    this.id,
    required this.name,
    required this.color,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  CategoryEntity copyWith({
    int? id,
    String? name,
    String? color,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, color, icon, createdAt, updatedAt];
}