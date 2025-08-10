import 'package:dartz/dartz.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository_interface.dart';

/// Use case for toggling todo completion status
class ToggleTodoUseCase {
  final TodoRepositoryInterface _repository;

  ToggleTodoUseCase(this._repository);

  /// Execute the use case to toggle todo completion
  Future<Either<String, TodoEntity>> execute(int todoId) async {
    try {
      // Get the todo first
      final todoResult = await _repository.getTodoById(todoId);
      
      return todoResult.fold(
        (error) => Left(error),
        (todo) async {
          if (todo == null) {
            return const Left('Todo not found');
          }

          // Toggle completion status
          return await _repository.toggleTodoCompletion(todoId);
        },
      );
    } catch (e) {
      return Left('Failed to toggle todo: ${e.toString()}');
    }
  }

  /// Mark todo as completed
  Future<Either<String, TodoEntity>> markCompleted(int todoId) async {
    try {
      final todoResult = await _repository.getTodoById(todoId);
      
      return todoResult.fold(
        (error) => Left(error),
        (todo) async {
          if (todo == null) {
            return const Left('Todo not found');
          }

          if (todo.isCompleted) {
            return Right(todo); // Already completed
          }

          final completedTodo = todo.markCompleted();
          return await _repository.updateTodo(completedTodo);
        },
      );
    } catch (e) {
      return Left('Failed to mark todo as completed: ${e.toString()}');
    }
  }

  /// Mark todo as incomplete
  Future<Either<String, TodoEntity>> markIncomplete(int todoId) async {
    try {
      final todoResult = await _repository.getTodoById(todoId);
      
      return todoResult.fold(
        (error) => Left(error),
        (todo) async {
          if (todo == null) {
            return const Left('Todo not found');
          }

          if (!todo.isCompleted) {
            return Right(todo); // Already incomplete
          }

          final incompleteTodo = todo.markIncomplete();
          return await _repository.updateTodo(incompleteTodo);
        },
      );
    } catch (e) {
      return Left('Failed to mark todo as incomplete: ${e.toString()}');
    }
  }

  /// Toggle completion status for multiple todos
  Future<Either<String, List<TodoEntity>>> executeMultiple(List<int> todoIds) async {
    try {
      final toggledTodos = <TodoEntity>[];
      
      for (final todoId in todoIds) {
        final result = await execute(todoId);
        if (result.isLeft()) {
          return result.fold((error) => Left('Failed to toggle todo $todoId: $error'), (r) => Left('Unknown error'));
        }
        
        final toggledTodo = result.getOrElse(() => throw Exception('Todo not found'));
        toggledTodos.add(toggledTodo);
      }
      
      return Right(toggledTodos);
    } catch (e) {
      return Left('Failed to toggle multiple todos: ${e.toString()}');
    }
  }

  /// Mark all todos in a category as completed
  Future<Either<String, List<TodoEntity>>> markCategoryCompleted(String category) async {
    try {
      final todosResult = await _repository.getTodosByCategory(category);
      
      return todosResult.fold(
        (error) => Left(error),
        (todos) async {
          final incompleteTodos = todos.where((todo) => !todo.isCompleted).toList();
          
          if (incompleteTodos.isEmpty) {
            return Right(todos); // All already completed
          }
          
          final todoIds = incompleteTodos.map((todo) => todo.id!).toList();
          return await executeMultiple(todoIds);
        },
      );
    } catch (e) {
      return Left('Failed to mark category as completed: ${e.toString()}');
    }
  }

  /// Mark all todos with specific priority as completed
  Future<Either<String, List<TodoEntity>>> markPriorityCompleted(TodoPriority priority) async {
    try {
      final todosResult = await _repository.getTodosByPriority(priority);
      
      return todosResult.fold(
        (error) => Left(error),
        (todos) async {
          final incompleteTodos = todos.where((todo) => !todo.isCompleted).toList();
          
          if (incompleteTodos.isEmpty) {
            return Right(todos); // All already completed
          }
          
          final todoIds = incompleteTodos.map((todo) => todo.id!).toList();
          return await executeMultiple(todoIds);
        },
      );
    } catch (e) {
      return Left('Failed to mark priority todos as completed: ${e.toString()}');
    }
  }

  /// Mark all overdue todos as completed
  Future<Either<String, List<TodoEntity>>> markOverdueCompleted() async {
    try {
      final overdueResult = await _repository.getOverdueTodos();
      
      return overdueResult.fold(
        (error) => Left(error),
        (todos) async {
          if (todos.isEmpty) {
            return Right(todos); // No overdue todos
          }
          
          final todoIds = todos.map((todo) => todo.id!).toList();
          return await executeMultiple(todoIds);
        },
      );
    } catch (e) {
      return Left('Failed to mark overdue todos as completed: ${e.toString()}');
    }
  }

  /// Mark all todos due today as completed
  Future<Either<String, List<TodoEntity>>> markTodayCompleted() async {
    try {
      final todayResult = await _repository.getTodosForToday();
      
      return todayResult.fold(
        (error) => Left(error),
        (todos) async {
          final incompleteTodos = todos.where((todo) => !todo.isCompleted).toList();
          
          if (incompleteTodos.isEmpty) {
            return Right(todos); // All already completed
          }
          
          final todoIds = incompleteTodos.map((todo) => todo.id!).toList();
          return await executeMultiple(todoIds);
        },
      );
    } catch (e) {
      return Left('Failed to mark today\'s todos as completed: ${e.toString()}');
    }
  }

  /// Get completion statistics after toggle operations
  Future<Either<String, ToggleStats>> getToggleStats(List<int> todoIds) async {
    try {
      int completed = 0;
      int incomplete = 0;
      int notFound = 0;
      
      for (final todoId in todoIds) {
        final todoResult = await _repository.getTodoById(todoId);
        
        if (todoResult.isLeft()) {
          notFound++;
        } else {
          final todo = todoResult.getOrElse(() => null);
          if (todo == null) {
            notFound++;
          } else if (todo.isCompleted) {
            completed++;
          } else {
            incomplete++;
          }
        }
      }
      
      return Right(ToggleStats(
        total: todoIds.length,
        completed: completed,
        incomplete: incomplete,
        notFound: notFound,
      ));
    } catch (e) {
      return Left('Failed to get toggle stats: ${e.toString()}');
    }
  }
}

/// Statistics for toggle operations
class ToggleStats {
  final int total;
  final int completed;
  final int incomplete;
  final int notFound;

  const ToggleStats({
    required this.total,
    required this.completed,
    required this.incomplete,
    required this.notFound,
  });

  /// Get completion percentage
  double get completionPercentage {
    if (total == 0) return 0.0;
    return (completed / total) * 100;
  }

  /// Check if all todos were found
  bool get allFound => notFound == 0;

  /// Check if all todos are completed
  bool get allCompleted => completed == total && notFound == 0;

  @override
  String toString() {
    return 'ToggleStats(total: $total, completed: $completed, incomplete: $incomplete, notFound: $notFound)';
  }
}