import 'package:dartz/dartz.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository_interface.dart';

/// Use case for getting todos with various filtering options
class GetTodosUseCase {
  final TodoRepositoryInterface _repository;

  GetTodosUseCase(this._repository);

  /// Get all todos
  Future<Either<String, List<TodoEntity>>> execute() async {
    try {
      return await _repository.getTodos();
    } catch (e) {
      return Left('Failed to get todos: ${e.toString()}');
    }
  }

  /// Get todos by filter options
  Future<Either<String, List<TodoEntity>>> getFilteredTodos({
    String? category,
    TodoPriority? priority,
    bool? isCompleted,
    bool? isOverdue,
    bool? isDueToday,
  }) async {
    try {
      List<TodoEntity> todos = [];

      if (category != null) {
        final result = await _repository.getTodosByCategory(category);
        if (result.isLeft()) return result;
        todos = result.getOrElse(() => []);
      } else if (priority != null) {
        final result = await _repository.getTodosByPriority(priority);
        if (result.isLeft()) return result;
        todos = result.getOrElse(() => []);
      } else if (isCompleted == true) {
        final result = await _repository.getCompletedTodos();
        if (result.isLeft()) return result;
        todos = result.getOrElse(() => []);
      } else if (isCompleted == false) {
        final result = await _repository.getPendingTodos();
        if (result.isLeft()) return result;
        todos = result.getOrElse(() => []);
      } else if (isOverdue == true) {
        final result = await _repository.getOverdueTodos();
        if (result.isLeft()) return result;
        todos = result.getOrElse(() => []);
      } else if (isDueToday == true) {
        final result = await _repository.getTodosForToday();
        if (result.isLeft()) return result;
        todos = result.getOrElse(() => []);
      } else {
        final result = await _repository.getTodos();
        if (result.isLeft()) return result;
        todos = result.getOrElse(() => []);
      }

      return Right(todos);
    } catch (e) {
      return Left('Failed to get filtered todos: ${e.toString()}');
    }
  }

  /// Get todo by ID
  Future<Either<String, TodoEntity?>> getTodoById(int id) async {
    try {
      return await _repository.getTodoById(id);
    } catch (e) {
      return Left('Failed to get todo: ${e.toString()}');
    }
  }

  /// Search todos by query
  Future<Either<String, List<TodoEntity>>> searchTodos(String query) async {
    try {
      if (query.trim().isEmpty) {
        return const Right([]);
      }
      return await _repository.searchTodos(query);
    } catch (e) {
      return Left('Failed to search todos: ${e.toString()}');
    }
  }

  /// Get todo statistics
  Future<Either<String, TodoStats>> getTodoStats() async {
    try {
      return await _repository.getTodoStats();
    } catch (e) {
      return Left('Failed to get todo statistics: ${e.toString()}');
    }
  }

  /// Get todos grouped by category
  Future<Either<String, Map<String, List<TodoEntity>>>> getTodosGroupedByCategory() async {
    try {
      final todosResult = await _repository.getTodos();
      
      return todosResult.fold(
        (error) => Left(error),
        (todos) {
          final grouped = <String, List<TodoEntity>>{};
          
          for (final todo in todos) {
            final category = todo.category ?? 'Uncategorized';
            if (!grouped.containsKey(category)) {
              grouped[category] = [];
            }
            grouped[category]!.add(todo);
          }
          
          return Right(grouped);
        },
      );
    } catch (e) {
      return Left('Failed to group todos by category: ${e.toString()}');
    }
  }

  /// Get todos grouped by priority
  Future<Either<String, Map<TodoPriority, List<TodoEntity>>>> getTodosGroupedByPriority() async {
    try {
      final todosResult = await _repository.getTodos();
      
      return todosResult.fold(
        (error) => Left(error),
        (todos) {
          final grouped = <TodoPriority, List<TodoEntity>>{};
          
          for (final priority in TodoPriority.values) {
            grouped[priority] = todos.where((todo) => todo.priority == priority).toList();
          }
          
          return Right(grouped);
        },
      );
    } catch (e) {
      return Left('Failed to group todos by priority: ${e.toString()}');
    }
  }

  /// Get upcoming todos (due within next 7 days)
  Future<Either<String, List<TodoEntity>>> getUpcomingTodos() async {
    try {
      final todosResult = await _repository.getPendingTodos();
      
      return todosResult.fold(
        (error) => Left(error),
        (todos) {
          final upcoming = todos.where((todo) => todo.isDueSoon).toList();
          upcoming.sort((a, b) {
            if (a.dueDate == null && b.dueDate == null) return 0;
            if (a.dueDate == null) return 1;
            if (b.dueDate == null) return -1;
            return a.dueDate!.compareTo(b.dueDate!);
          });
          return Right(upcoming);
        },
      );
    } catch (e) {
      return Left('Failed to get upcoming todos: ${e.toString()}');
    }
  }

  /// Get categories with todo counts
  Future<Either<String, List<CategoryWithCount>>> getCategoriesWithCount() async {
    try {
      final categoriesResult = await _repository.getCategories();
      if (categoriesResult.isLeft()) return categoriesResult.fold((l) => Left(l), (r) => Left('Unknown error'));

      final todosResult = await _repository.getTodos();
      if (todosResult.isLeft()) return todosResult.fold((l) => Left(l), (r) => Left('Unknown error'));

      final categories = categoriesResult.getOrElse(() => []);
      final todos = todosResult.getOrElse(() => []);

      final categoriesWithCount = categories.map((category) {
        final todoCount = todos.where((todo) => todo.category == category.name).length;
        return CategoryWithCount(category: category, todoCount: todoCount);
      }).toList();

      return Right(categoriesWithCount);
    } catch (e) {
      return Left('Failed to get categories with count: ${e.toString()}');
    }
  }
}

/// Data class for category with todo count
class CategoryWithCount {
  final CategoryEntity category;
  final int todoCount;

  CategoryWithCount({
    required this.category,
    required this.todoCount,
  });
}