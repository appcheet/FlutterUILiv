import 'package:dartz/dartz.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository_interface.dart';

/// Use case for adding new todos with validation
class AddTodoUseCase {
  final TodoRepositoryInterface _repository;

  AddTodoUseCase(this._repository);

  /// Execute the use case to add a new todo
  Future<Either<String, TodoEntity>> execute(AddTodoParams params) async {
    try {
      // Validate input
      final validationResult = _validateTodo(params);
      if (validationResult.isLeft()) {
        return validationResult.fold((error) => Left(error), (r) => Left('Validation failed'));
      }

      // Create todo entity
      final now = DateTime.now();
      final todo = TodoEntity(
        title: params.title.trim(),
        description: params.description?.trim(),
        priority: params.priority,
        category: params.category?.trim(),
        dueDate: params.dueDate,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      // Add to repository
      return await _repository.addTodo(todo);
    } catch (e) {
      return Left('Failed to add todo: ${e.toString()}');
    }
  }

  /// Validate todo input
  Either<String, bool> _validateTodo(AddTodoParams params) {
    // Title validation
    if (params.title.trim().isEmpty) {
      return const Left('Title cannot be empty');
    }

    if (params.title.trim().length < 2) {
      return const Left('Title must be at least 2 characters long');
    }

    if (params.title.trim().length > 100) {
      return const Left('Title cannot exceed 100 characters');
    }

    // Description validation
    if (params.description != null && params.description!.length > 500) {
      return const Left('Description cannot exceed 500 characters');
    }

    // Due date validation
    if (params.dueDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dueDay = DateTime(params.dueDate!.year, params.dueDate!.month, params.dueDate!.day);
      
      if (dueDay.isBefore(today)) {
        return const Left('Due date cannot be in the past');
      }
    }

    // Category validation
    if (params.category != null && params.category!.trim().length > 50) {
      return const Left('Category name cannot exceed 50 characters');
    }

    return const Right(true);
  }

  /// Add multiple todos at once
  Future<Either<String, List<TodoEntity>>> executeMultiple(List<AddTodoParams> todosList) async {
    try {
      final addedTodos = <TodoEntity>[];
      
      for (final params in todosList) {
        final result = await execute(params);
        if (result.isLeft()) {
          return result.fold((error) => Left('Failed to add todo "${params.title}": $error'), (r) => Left('Unknown error'));
        }
        
        final addedTodo = result.getOrElse(() => throw Exception('Todo not found'));
        addedTodos.add(addedTodo);
      }
      
      return Right(addedTodos);
    } catch (e) {
      return Left('Failed to add multiple todos: ${e.toString()}');
    }
  }

  /// Add todo with category creation if needed
  Future<Either<String, TodoEntity>> executeWithCategoryCreation(
    AddTodoParams params,
    String? categoryColor,
    String? categoryIcon,
  ) async {
    try {
      // If category is provided and doesn't exist, create it first
      if (params.category != null && params.category!.trim().isNotEmpty) {
        final categoriesResult = await _repository.getCategories();
        if (categoriesResult.isRight()) {
          final categories = categoriesResult.getOrElse(() => []);
          final categoryExists = categories.any((c) => c.name.toLowerCase() == params.category!.toLowerCase());
          
          if (!categoryExists) {
            final now = DateTime.now();
            final newCategory = CategoryEntity(
              name: params.category!.trim(),
              color: categoryColor ?? '#2196F3', // Default blue color
              icon: categoryIcon,
              createdAt: now,
              updatedAt: now,
            );
            
            final addCategoryResult = await _repository.addCategory(newCategory);
            if (addCategoryResult.isLeft()) {
              return addCategoryResult.fold((error) => Left('Failed to create category: $error'), (r) => Left('Unknown error'));
            }
          }
        }
      }
      
      // Add the todo
      return await execute(params);
    } catch (e) {
      return Left('Failed to add todo with category creation: ${e.toString()}');
    }
  }

  /// Add recurring todo (creates multiple todos with different due dates)
  Future<Either<String, List<TodoEntity>>> executeRecurring(
    AddTodoParams params,
    RecurrencePattern pattern,
  ) async {
    try {
      if (params.dueDate == null) {
        return const Left('Due date is required for recurring todos');
      }

      final todos = <AddTodoParams>[];
      final baseDueDate = params.dueDate!;
      
      switch (pattern.type) {
        case RecurrenceType.daily:
          for (int i = 0; i < pattern.count; i++) {
            final dueDate = baseDueDate.add(Duration(days: i * pattern.interval));
            todos.add(params.copyWith(
              title: pattern.count > 1 ? '${params.title} (${i + 1}/${pattern.count})' : params.title,
              dueDate: dueDate,
            ));
          }
          break;
        case RecurrenceType.weekly:
          for (int i = 0; i < pattern.count; i++) {
            final dueDate = baseDueDate.add(Duration(days: i * 7 * pattern.interval));
            todos.add(params.copyWith(
              title: pattern.count > 1 ? '${params.title} (Week ${i + 1})' : params.title,
              dueDate: dueDate,
            ));
          }
          break;
        case RecurrenceType.monthly:
          for (int i = 0; i < pattern.count; i++) {
            final dueDate = DateTime(
              baseDueDate.year,
              baseDueDate.month + (i * pattern.interval),
              baseDueDate.day,
            );
            todos.add(params.copyWith(
              title: pattern.count > 1 ? '${params.title} (Month ${i + 1})' : params.title,
              dueDate: dueDate,
            ));
          }
          break;
      }
      
      return await executeMultiple(todos);
    } catch (e) {
      return Left('Failed to create recurring todos: ${e.toString()}');
    }
  }
}

/// Parameters for adding a todo
class AddTodoParams {
  final String title;
  final String? description;
  final TodoPriority priority;
  final String? category;
  final DateTime? dueDate;

  const AddTodoParams({
    required this.title,
    this.description,
    this.priority = TodoPriority.medium,
    this.category,
    this.dueDate,
  });

  AddTodoParams copyWith({
    String? title,
    String? description,
    TodoPriority? priority,
    String? category,
    DateTime? dueDate,
  }) {
    return AddTodoParams(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

/// Recurrence pattern for recurring todos
class RecurrencePattern {
  final RecurrenceType type;
  final int interval; // Every X days/weeks/months
  final int count; // Number of occurrences

  const RecurrencePattern({
    required this.type,
    this.interval = 1,
    required this.count,
  });
}

/// Types of recurrence
enum RecurrenceType {
  daily,
  weekly,
  monthly,
}