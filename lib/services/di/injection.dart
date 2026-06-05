import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../services/storage/storage_service.dart';
import '../../services/database/database_service.dart';
import '../../services/network/api_service.dart';
import '../../architecture/data/repositories/user_repository.dart';
import '../../architecture/data/repositories/todo_repository.dart';
import '../../architecture/domain/repositories/user_repository_interface.dart';
import '../../architecture/domain/repositories/todo_repository_interface.dart';
import '../../architecture/domain/usecases/get_users_usecase.dart';
import '../../architecture/domain/usecases/add_todo_usecase.dart';
import '../../architecture/domain/usecases/get_todos_usecase.dart';
import '../../architecture/domain/usecases/toggle_todo_usecase.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  final dio = Dio();
  dio.options.baseUrl = 'https://jsonplaceholder.typicode.com/';
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  getIt.registerSingleton<Dio>(dio);
  
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );
  getIt.registerSingleton<Logger>(logger);
  
  // Services
  getIt.registerLazySingleton<StorageService>(
    () => StorageService(getIt<SharedPreferences>()),
  );
  
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());
  
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(getIt<Dio>(), getIt<Logger>()),
  );
  
  // Repositories
  getIt.registerLazySingleton<UserRepositoryInterface>(
    () => UserRepository(
      storageService: getIt<StorageService>(),
    ),
  );
  
  getIt.registerLazySingleton<TodoRepositoryInterface>(
    () => TodoRepository(
      databaseService: getIt<DatabaseService>(),
    ),
  );
  
  // Use Cases
  getIt.registerLazySingleton(() => GetUsersUseCase(getIt<UserRepositoryInterface>()));
  getIt.registerLazySingleton(() => GetTodosUseCase(getIt<TodoRepositoryInterface>()));
  getIt.registerLazySingleton(() => AddTodoUseCase(getIt<TodoRepositoryInterface>()));
  getIt.registerLazySingleton(() => ToggleTodoUseCase(getIt<TodoRepositoryInterface>()));
}

// Getters for easy access
T inject<T extends Object>() => getIt.get<T>();