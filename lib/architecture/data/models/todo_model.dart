import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/todo_entity.dart';

part 'todo_model.g.dart';

/// Data model for Todo - handles serialization and conversion to/from entity
@JsonSerializable(explicitToJson: true)
class TodoModel {
  final int? id;
  final String title;
  final String? description;
  @JsonKey(name: 'completed')
  final bool isCompleted;
  final int priority; // Store as int for database compatibility
  final String? category;
  @JsonKey(name: 'dueDate')
  final String? dueDateString; // ISO string format
  @JsonKey(name: 'createdAt')
  final String createdAtString;
  @JsonKey(name: 'updatedAt')
  final String updatedAtString;

  const TodoModel({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = 1, // Default to medium
    this.category,
    this.dueDateString,
    required this.createdAtString,
    required this.updatedAtString,
  });

  /// Create TodoModel from JSON
  factory TodoModel.fromJson(Map<String, dynamic> json) => _$TodoModelFromJson(json);

  /// Convert TodoModel to JSON
  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  /// Convert to domain entity
  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      priority: TodoPriority.fromValue(priority),
      category: category,
      dueDate: dueDateString != null ? DateTime.parse(dueDateString!) : null,
      createdAt: DateTime.parse(createdAtString),
      updatedAt: DateTime.parse(updatedAtString),
    );
  }

  /// Create from domain entity
  factory TodoModel.fromEntity(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      isCompleted: entity.isCompleted,
      priority: entity.priority.value,
      category: entity.category,
      dueDateString: entity.dueDate?.toIso8601String(),
      createdAtString: entity.createdAt.toIso8601String(),
      updatedAtString: entity.updatedAt.toIso8601String(),
    );
  }

  /// Create from database map
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: (map['isCompleted'] as int) == 1,
      priority: map['priority'] as int? ?? 1,
      category: map['category'] as String?,
      dueDateString: map['dueDate'] as String?,
      createdAtString: map['createdAt'] as String,
      updatedAtString: map['updatedAt'] as String,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'priority': priority,
      'category': category,
      'dueDate': dueDateString,
      'createdAt': createdAtString,
      'updatedAt': updatedAtString,
    };
  }

  /// Create a copy with updated fields
  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? priority,
    String? category,
    String? dueDateString,
    String? createdAtString,
    String? updatedAtString,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      dueDateString: dueDateString ?? this.dueDateString,
      createdAtString: createdAtString ?? this.createdAtString,
      updatedAtString: updatedAtString ?? this.updatedAtString,
    );
  }
}

/// Data model for Category
@JsonSerializable()
class CategoryModel {
  final int? id;
  final String name;
  final String color;
  final String? icon;
  @JsonKey(name: 'createdAt')
  final String createdAtString;
  @JsonKey(name: 'updatedAt')
  final String updatedAtString;

  const CategoryModel({
    this.id,
    required this.name,
    required this.color,
    this.icon,
    required this.createdAtString,
    required this.updatedAtString,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      color: color,
      icon: icon,
      createdAt: DateTime.parse(createdAtString),
      updatedAt: DateTime.parse(updatedAtString),
    );
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      color: entity.color,
      icon: entity.icon,
      createdAtString: entity.createdAt.toIso8601String(),
      updatedAtString: entity.updatedAt.toIso8601String(),
    );
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      color: map['color'] as String,
      icon: map['icon'] as String?,
      createdAtString: map['createdAt'] as String,
      updatedAtString: map['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
      'createdAt': createdAtString,
      'updatedAt': updatedAtString,
    };
  }
}