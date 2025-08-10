import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository_interface.dart';

/// Use case for getting users
/// Implements business logic and coordinates between repository and presentation layer
class GetUsersUseCase {
  final UserRepositoryInterface _repository;

  GetUsersUseCase(this._repository);

  /// Execute the use case to get all users
  /// First tries to get cached users, then fetches from remote if needed
  Future<Either<String, List<UserEntity>>> execute({
    bool forceRefresh = false,
  }) async {
    try {
      // If not forcing refresh, try to get cached users first
      if (!forceRefresh) {
        final cachedResult = await _repository.getCachedUsers();
        if (cachedResult.isRight()) {
          final cachedUsers = cachedResult.getOrElse(() => []);
          if (cachedUsers.isNotEmpty) {
            return Right(cachedUsers);
          }
        }
      }

      // Fetch users from remote
      final remoteResult = await _repository.getUsers();
      
      return remoteResult.fold(
        (error) => Left(error),
        (users) async {
          // Save users to cache for future use
          for (final user in users) {
            await _repository.saveUser(user);
          }
          return Right(users);
        },
      );
    } catch (e) {
      return Left('Failed to get users: ${e.toString()}');
    }
  }

  /// Get user by ID with caching strategy
  Future<Either<String, UserEntity?>> getUserById(int id) async {
    try {
      // Check if user exists locally first
      if (await _repository.userExistsLocally(id)) {
        // Try to get from cache
        final cachedResult = await _repository.getCachedUsers();
        if (cachedResult.isRight()) {
          final cachedUsers = cachedResult.getOrElse(() => []);
          final user = cachedUsers.where((u) => u.id == id).firstOrNull;
          if (user != null) {
            return Right(user);
          }
        }
      }

      // If not in cache, fetch from remote
      final remoteResult = await _repository.getUserById(id);
      
      return remoteResult.fold(
        (error) => Left(error),
        (user) async {
          // Save to cache if found
          if (user != null) {
            await _repository.saveUser(user);
          }
          return Right(user);
        },
      );
    } catch (e) {
      return Left('Failed to get user: ${e.toString()}');
    }
  }

  /// Search users with caching
  Future<Either<String, List<UserEntity>>> searchUsers(String query) async {
    try {
      if (query.trim().isEmpty) {
        return const Right([]);
      }

      // First try to search in cached users
      final cachedResult = await _repository.getCachedUsers();
      if (cachedResult.isRight()) {
        final cachedUsers = cachedResult.getOrElse(() => []);
        if (cachedUsers.isNotEmpty) {
          final filteredUsers = cachedUsers
              .where((user) =>
                  user.name.toLowerCase().contains(query.toLowerCase()) ||
                  user.username.toLowerCase().contains(query.toLowerCase()) ||
                  user.email.toLowerCase().contains(query.toLowerCase()))
              .toList();
          
          if (filteredUsers.isNotEmpty) {
            return Right(filteredUsers);
          }
        }
      }

      // If no cached results, search remotely
      return await _repository.searchUsers(query);
    } catch (e) {
      return Left('Failed to search users: ${e.toString()}');
    }
  }

  /// Sync users from remote to local storage
  Future<Either<String, bool>> syncUsers() async {
    try {
      return await _repository.syncUsers();
    } catch (e) {
      return Left('Failed to sync users: ${e.toString()}');
    }
  }

  /// Clear user cache
  Future<Either<String, bool>> clearCache() async {
    try {
      return await _repository.clearCache();
    } catch (e) {
      return Left('Failed to clear cache: ${e.toString()}');
    }
  }

  /// Clear cache and refresh data
  Future<void> clearAndRefresh() async {
    await clearCache();
  }
}

/// Extension for List&lt;UserEntity&gt;
extension UserListExtension on List<UserEntity> {
  /// Get first user or null if empty
  UserEntity? get firstOrNull => isEmpty ? null : first;

  /// Sort users by name
  List<UserEntity> sortedByName() {
    final sorted = List<UserEntity>.from(this);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }

  /// Sort users by username
  List<UserEntity> sortedByUsername() {
    final sorted = List<UserEntity>.from(this);
    sorted.sort((a, b) => a.username.compareTo(b.username));
    return sorted;
  }

  /// Filter users by domain
  List<UserEntity> filterByEmailDomain(String domain) {
    return where((user) => user.email.endsWith('@$domain')).toList();
  }

  /// Get users with company
  List<UserEntity> withCompany() {
    return where((user) => user.company != null).toList();
  }

  /// Get users with website
  List<UserEntity> withWebsite() {
    return where((user) => user.website != null && user.website!.isNotEmpty).toList();
  }
}