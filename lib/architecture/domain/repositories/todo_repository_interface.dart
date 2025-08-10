import 'package:dartz/dartz.dart';
import '../entities/todo_entity.dart';

/// Abstract repository interface for todo operations
/// This defines the contract that data layer must implement
abstract class TodoRepositoryInterface {
  /// Get all todos
  Future<Either<String, List<TodoEntity>>> getTodos();

  /// Get todo by ID
  Future<Either<String, TodoEntity?>> getTodoById(int id);

  /// Get todos by category
  Future<Either<String, List<TodoEntity>>> getTodosByCategory(String category);

  /// Get todos by priority
  Future<Either<String, List<TodoEntity>>> getTodosByPriority(TodoPriority priority);

  /// Get completed todos
  Future<Either<String, List<TodoEntity>>> getCompletedTodos();

  /// Get pending todos
  Future<Either<String, List<TodoEntity>>> getPendingTodos();

  /// Get overdue todos
  Future<Either<String, List<TodoEntity>>> getOverdueTodos();

  /// Get todos due today
  Future<Either<String, List<TodoEntity>>> getTodosForToday();

  /// Add new todo
  Future<Either<String, TodoEntity>> addTodo(TodoEntity todo);

  /// Update existing todo
  Future<Either<String, TodoEntity>> updateTodo(TodoEntity todo);

  /// Delete todo
  Future<Either<String, bool>> deleteTodo(int id);

  /// Toggle todo completion status
  Future<Either<String, TodoEntity>> toggleTodoCompletion(int id);

  /// Search todos by title or description
  Future<Either<String, List<TodoEntity>>> searchTodos(String query);

  /// Get todo statistics
  Future<Either<String, TodoStats>> getTodoStats();

  /// Clear all completed todos
  Future<Either<String, bool>> clearCompletedTodos();

  /// Get categories
  Future<Either<String, List<CategoryEntity>>> getCategories();

  /// Add category
  Future<Either<String, CategoryEntity>> addCategory(CategoryEntity category);

  /// Update category
  Future<Either<String, CategoryEntity>> updateCategory(CategoryEntity category);

  /// Delete category
  Future<Either<String, bool>> deleteCategory(int id);
}

/// Todo statistics data class
class TodoStats {
  final int total;
  final int completed;
  final int pending;
  final int overdue;
  final int dueToday;
  final Map<TodoPriority, int> priorityCount;
  final Map<String, int> categoryCount;

  const TodoStats({
    required this.total,
    required this.completed,
    required this.pending,
    required this.overdue,
    required this.dueToday,
    required this.priorityCount,
    required this.categoryCount,
  });

  /// Get completion percentage
  double get completionPercentage {
    if (total == 0) return 0.0;
    return (completed / total) * 100;
  }

  /// Get pending percentage
  double get pendingPercentage {
    if (total == 0) return 0.0;
    return (pending / total) * 100;
  }

  /// Get overdue percentage
  double get overduePercentage {
    if (total == 0) return 0.0;
    return (overdue / total) * 100;
  }
}