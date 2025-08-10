import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository_interface.dart';
import '../../../services/storage/storage_service.dart';
import '../../../services/data/mock_data_service.dart';
import '../models/user_model.dart';

/// Implementation of UserRepositoryInterface
class UserRepository implements UserRepositoryInterface {
  final StorageService _storageService;

  UserRepository({
    required StorageService storageService,
  }) : _storageService = storageService;

  @override
  Future<Either<String, List<UserEntity>>> getUsers() async {
    try {
      // Use mock data instead of API to avoid 403 errors
      final users = await MockDataService.fetchUsersAsync();
      return Right(users);
    } catch (e) {
      return Left('Failed to fetch users: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, UserEntity?>> getUserById(int id) async {
    try {
      // Use mock data instead of API
      final users = await MockDataService.fetchUsersAsync();
      final user = MockDataService.getUserById(users, id);
      return Right(user);
    } catch (e) {
      return Left('Failed to fetch user: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<UserEntity>>> searchUsers(String query) async {
    try {
      // Use mock data for search
      final allUsers = await MockDataService.fetchUsersAsync();
      final filteredUsers = MockDataService.searchUsers(allUsers, query);
      return Right(filteredUsers);
    } catch (e) {
      return Left('Failed to search users: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> saveUser(UserEntity user) async {
    try {
      // Get existing users from storage
      final existingUsers = await getCachedUsers();
      List<UserEntity> usersList = [];
      
      if (existingUsers.isRight()) {
        usersList = existingUsers.getOrElse(() => []);
      }

      // Remove existing user with same ID if exists
      usersList.removeWhere((u) => u.id == user.id);
      
      // Add the new user
      usersList.add(user);

      // Convert to models and save
      final usersData = usersList.map((u) => UserModel.fromEntity(u).toJson()).toList();
      final success = await _storageService.setObjectList(StorageKeys.cachedUsers, usersData);
      
      return Right(success);
    } catch (e) {
      return Left('Failed to save user: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> removeUser(int id) async {
    try {
      final existingUsers = await getCachedUsers();
      
      if (existingUsers.isLeft()) {
        return existingUsers.fold((error) => Left(error), (r) => Left('Unknown error'));
      }

      final usersList = existingUsers.getOrElse(() => []);
      usersList.removeWhere((u) => u.id == id);

      final usersData = usersList.map((u) => UserModel.fromEntity(u).toJson()).toList();
      final success = await _storageService.setObjectList(StorageKeys.cachedUsers, usersData);
      
      return Right(success);
    } catch (e) {
      return Left('Failed to remove user: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<UserEntity>>> getCachedUsers() async {
    try {
      final usersData = _storageService.getObjectList(StorageKeys.cachedUsers);
      
      if (usersData == null || usersData.isEmpty) {
        return const Right([]);
      }

      final users = usersData.map((userData) => UserModel.fromJson(userData).toEntity()).toList();
      return Right(users);
    } catch (e) {
      return Left('Failed to get cached users: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> syncUsers() async {
    try {
      // Get users from remote
      final remoteResult = await getUsers();
      
      if (remoteResult.isLeft()) {
        return remoteResult.fold((error) => Left(error), (r) => Left('Unknown error'));
      }

      final remoteUsers = remoteResult.getOrElse(() => []);
      
      // Clear existing cache and save new users
      await _storageService.remove(StorageKeys.cachedUsers);
      
      for (final user in remoteUsers) {
        await saveUser(user);
      }

      // Save last sync timestamp
      await _storageService.setString(StorageKeys.lastSync, DateTime.now().toIso8601String());
      
      return const Right(true);
    } catch (e) {
      return Left('Failed to sync users: ${e.toString()}');
    }
  }

  @override
  Future<bool> userExistsLocally(int id) async {
    try {
      final cachedUsers = await getCachedUsers();
      
      if (cachedUsers.isLeft()) return false;

      final users = cachedUsers.getOrElse(() => []);
      return users.any((user) => user.id == id);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<String, bool>> clearCache() async {
    try {
      final success = await _storageService.remove(StorageKeys.cachedUsers);
      return Right(success);
    } catch (e) {
      return Left('Failed to clear cache: ${e.toString()}');
    }
  }

  /// Get last sync timestamp
  DateTime? getLastSyncTime() {
    final syncTimeString = _storageService.getString(StorageKeys.lastSync);
    if (syncTimeString != null) {
      return DateTime.parse(syncTimeString);
    }
    return null;
  }

  /// Check if cache is stale (older than specified duration)
  bool isCacheStale({Duration maxAge = const Duration(hours: 1)}) {
    final lastSync = getLastSyncTime();
    if (lastSync == null) return true;
    
    final now = DateTime.now();
    return now.difference(lastSync) > maxAge;
  }
}

