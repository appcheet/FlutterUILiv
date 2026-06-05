import 'package:dartz/dartz.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository_interface.dart';
import '../../../services/database/database_service.dart';
import '../models/todo_model.dart';

/// Implementation of TodoRepositoryInterface
class TodoRepository implements TodoRepositoryInterface {
  final DatabaseService _databaseService;

  TodoRepository({
    required DatabaseService databaseService,
  }) : _databaseService = databaseService;

  @override
  Future<Either<String, List<TodoEntity>>> getTodos() async {
    try {
      final todosData = await _databaseService.getAll(DbTables.todos, orderBy: 'createdAt DESC');
      final todos = todosData.map((data) => TodoModel.fromMap(data).toEntity()).toList();
      return Right(todos);
    } catch (e) {
      return Left('Failed to get todos: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, TodoEntity?>> getTodoById(int id) async {
    try {
      final todoData = await _databaseService.getById(DbTables.todos, id);
      if (todoData != null) {
        final todo = TodoModel.fromMap(todoData).toEntity();
        return Right(todo);
      }
      return const Right(null);
    } catch (e) {
      return Left('Failed to get todo: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<TodoEntity>>> getTodosByCategory(String category) async {
    try {
      final todosData = await _databaseService.getAll(
        DbTables.todos,
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'createdAt DESC',
      );
      final todos = todosData.map((data) => TodoModel.fromMap(data).toEntity()).toList();
      return Right(todos);
    } catch (e) {
      return Left('Failed to get todos by category: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<TodoEntity>>> getTodosByPriority(TodoPriority priority) async {
    try {
      final todosData = await _databaseService.getAll(
        DbTables.todos,
        where: 'priority = ?',
        whereArgs: [priority.value],
        orderBy: 'createdAt DESC',
      );
      final todos = todosData.map((data) => TodoModel.fromMap(data).toEntity()).toList();
      return Right(todos);
    } catch (e) {
      return Left('Failed to get todos by priority: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<TodoEntity>>> getCompletedTodos() async {
    try {
      final todosData = await _databaseService.getAll(
        DbTables.todos,
        where: 'isCompleted = ?',
        whereArgs: [1],
        orderBy: 'updatedAt DESC',
      );
      final todos = todosData.map((data) => TodoModel.fromMap(data).toEntity()).toList();
      return Right(todos);
    } catch (e) {
      return Left('Failed to get completed todos: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<TodoEntity>>> getPendingTodos() async {
    try {
      final todosData = await _databaseService.getAll(
        DbTables.todos,
        where: 'isCompleted = ?',
        whereArgs: [0],
        orderBy: 'createdAt DESC',
      );
      final todos = todosData.map((data) => TodoModel.fromMap(data).toEntity()).toList();
      return Right(todos);
    } catch (e) {
      return Left('Failed to get pending todos: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<TodoEntity>>> getOverdueTodos() async {
    try {
      final now = DateTime.now();
      final todosData = await _databaseService.getAll(
        DbTables.todos,
        where: 'isCompleted = ? AND dueDate IS NOT NULL AND dueDate < ?',
        whereArgs: [0, now.toIso8601String()],
        orderBy: 'dueDate ASC',
      );
      final todos = todosData.map((data) => TodoModel.fromMap(data).toEntity()).toList();
      return Right(todos);
    } catch (e) {
      return Left('Failed to get overdue todos: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<TodoEntity>>> getTodosForToday() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      final todosData = await _databaseService.getAll(
        DbTables.todos,
        where: 'dueDate >= ? AND dueDate < ?',
        whereArgs: [today.toIso8601String(), tomorrow.toIso8601String()],
        orderBy: 'dueDate ASC',
      );
      final todos = todosData.map((data) => TodoModel.fromMap(data).toEntity()).toList();
      return Right(todos);
    } catch (e) {
      return Left('Failed to get todos for today: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, TodoEntity>> addTodo(TodoEntity todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);
      final id = await _databaseService.insert(DbTables.todos, todoModel.toMap());
      
      final savedTodo = todo.copyWith(id: id);
      return Right(savedTodo);
    } catch (e) {
      return Left('Failed to add todo: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, TodoEntity>> updateTodo(TodoEntity todo) async {
    try {
      if (todo.id == null) {
        return const Left('Todo ID is required for update');
      }

      final todoModel = TodoModel.fromEntity(todo);
      await _databaseService.update(DbTables.todos, todoModel.toMap(), todo.id!);
      
      return Right(todo);
    } catch (e) {
      return Left('Failed to update todo: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> deleteTodo(int id) async {
    try {
      final deletedCount = await _databaseService.delete(DbTables.todos, id);
      return Right(deletedCount > 0);
    } catch (e) {
      return Left('Failed to delete todo: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, TodoEntity>> toggleTodoCompletion(int id) async {
    try {
      final todoResult = await getTodoById(id);
      if (todoResult.isLeft()) {
        return todoResult.fold((error) => Left(error), (r) => Left('Unknown error'));
      }

      final todo = todoResult.getOrElse(() => null);
      if (todo == null) {
        return const Left('Todo not found');
      }

      final toggledTodo = todo.toggleCompletion();
      return await updateTodo(toggledTodo);
    } catch (e) {
      return Left('Failed to toggle todo completion: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<TodoEntity>>> searchTodos(String query) async {
    try {
      final todosData = await _databaseService.getAll(
        DbTables.todos,
        where: 'title LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'createdAt DESC',
      );
      final todos = todosData.map((data) => TodoModel.fromMap(data).toEntity()).toList();
      return Right(todos);
    } catch (e) {
      return Left('Failed to search todos: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, TodoStats>> getTodoStats() async {
    try {
      final total = await _databaseService.count(DbTables.todos);
      final completed = await _databaseService.count(
        DbTables.todos,
        where: 'isCompleted = ?',
        whereArgs: [1],
      );
      final pending = total - completed;
      
      final now = DateTime.now();
      final overdue = await _databaseService.count(
        DbTables.todos,
        where: 'isCompleted = ? AND dueDate IS NOT NULL AND dueDate < ?',
        whereArgs: [0, now.toIso8601String()],
      );

      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final dueToday = await _databaseService.count(
        DbTables.todos,
        where: 'dueDate >= ? AND dueDate < ?',
        whereArgs: [today.toIso8601String(), tomorrow.toIso8601String()],
      );

      // Get priority counts
      final priorityCount = <TodoPriority, int>{};
      for (final priority in TodoPriority.values) {
        final count = await _databaseService.count(
          DbTables.todos,
          where: 'priority = ?',
          whereArgs: [priority.value],
        );
        priorityCount[priority] = count;
      }

      // Get category counts
      final categoryData = await _databaseService.rawQuery(
        'SELECT category, COUNT(*) as count FROM ${DbTables.todos} WHERE category IS NOT NULL GROUP BY category',
      );
      final categoryCount = <String, int>{};
      for (final row in categoryData) {
        final category = row['category'] as String;
        final count = row['count'] as int;
        categoryCount[category] = count;
      }

      final stats = TodoStats(
        total: total,
        completed: completed,
        pending: pending,
        overdue: overdue,
        dueToday: dueToday,
        priorityCount: priorityCount,
        categoryCount: categoryCount,
      );

      return Right(stats);
    } catch (e) {
      return Left('Failed to get todo stats: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> clearCompletedTodos() async {
    try {
      final deletedCount = await _databaseService.deleteWhere(
        DbTables.todos,
        'isCompleted = ?',
        [1],
      );
      return Right(deletedCount > 0);
    } catch (e) {
      return Left('Failed to clear completed todos: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<CategoryEntity>>> getCategories() async {
    try {
      final categoriesData = await _databaseService.getAll(DbTables.categories, orderBy: 'name ASC');
      final categories = categoriesData.map((data) => CategoryModel.fromMap(data).toEntity()).toList();
      return Right(categories);
    } catch (e) {
      return Left('Failed to get categories: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, CategoryEntity>> addCategory(CategoryEntity category) async {
    try {
      final categoryModel = CategoryModel.fromEntity(category);
      final id = await _databaseService.insert(DbTables.categories, categoryModel.toMap());
      
      final savedCategory = category.copyWith(id: id);
      return Right(savedCategory);
    } catch (e) {
      return Left('Failed to add category: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, CategoryEntity>> updateCategory(CategoryEntity category) async {
    try {
      if (category.id == null) {
        return const Left('Category ID is required for update');
      }

      final categoryModel = CategoryModel.fromEntity(category);
      await _databaseService.update(DbTables.categories, categoryModel.toMap(), category.id!);
      
      return Right(category);
    } catch (e) {
      return Left('Failed to update category: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> deleteCategory(int id) async {
    try {
      // First, update all todos with this category to have null category
      await _databaseService.rawExecute(
        'UPDATE ${DbTables.todos} SET category = NULL WHERE category = (SELECT name FROM ${DbTables.categories} WHERE id = ?)',
        [id],
      );

      // Then delete the category
      final deletedCount = await _databaseService.delete(DbTables.categories, id);
      return Right(deletedCount > 0);
    } catch (e) {
      return Left('Failed to delete category: ${e.toString()}');
    }
  }
}