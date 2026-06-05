import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

/// Abstract repository interface for user operations
/// This defines the contract that data layer must implement
abstract class UserRepositoryInterface {
  /// Get all users
  Future<Either<String, List<UserEntity>>> getUsers();

  /// Get user by ID
  Future<Either<String, UserEntity?>> getUserById(int id);

  /// Search users by name or username
  Future<Either<String, List<UserEntity>>> searchUsers(String query);

  /// Save user to cache/local storage
  Future<Either<String, bool>> saveUser(UserEntity user);

  /// Remove user from cache
  Future<Either<String, bool>> removeUser(int id);

  /// Get cached users
  Future<Either<String, List<UserEntity>>> getCachedUsers();

  /// Sync users from remote to local
  Future<Either<String, bool>> syncUsers();

  /// Check if user exists locally
  Future<bool> userExistsLocally(int id);

  /// Clear all cached users
  Future<Either<String, bool>> clearCache();
}