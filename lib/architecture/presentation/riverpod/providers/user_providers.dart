import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_users_usecase.dart';
import '../../../../services/di/injection.dart';

part 'user_providers.g.dart';

/// Provider for GetUsersUseCase
@riverpod
GetUsersUseCase getUsersUseCase(Ref ref) {
  return getIt<GetUsersUseCase>();
}

/// Provider for users list with proper error handling
@riverpod
class UsersNotifier extends _$UsersNotifier {
  @override
  Future<List<UserEntity>> build() {
    return _loadUsers();
  }

  /// Load users from use case
  Future<List<UserEntity>> _loadUsers({bool forceRefresh = false}) async {
    final useCase = ref.read(getUsersUseCaseProvider);
    final result = await useCase.execute(forceRefresh: forceRefresh);
    
    return result.fold(
      (error) => throw Exception(error),
      (users) => users,
    );
  }

  /// Refresh users
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final users = await _loadUsers(forceRefresh: true);
      state = AsyncValue.data(users);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Search users
  Future<void> searchUsers(String query) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(getUsersUseCaseProvider);
      final result = await useCase.searchUsers(query);
      
      final users = result.fold(
        (error) => throw Exception(error),
        (users) => users,
      );
      
      state = AsyncValue.data(users);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Get user by ID
  Future<UserEntity?> getUserById(int id) async {
    final useCase = ref.read(getUsersUseCaseProvider);
    final result = await useCase.getUserById(id);
    
    return result.fold(
      (error) => null,
      (user) => user,
    );
  }

  /// Clear cache
  Future<void> clearCache() async {
    final useCase = ref.read(getUsersUseCaseProvider);
    await useCase.clearCache();
    await refresh();
  }
}

/// Provider for search query
@riverpod
class UserSearchQuery extends _$UserSearchQuery {
  @override
  String build() {
    return '';
  }

  void updateQuery(String query) {
    state = query;
    // Trigger search when query changes
    if (query.isNotEmpty) {
      ref.read(usersNotifierProvider.notifier).searchUsers(query);
    } else {
      ref.read(usersNotifierProvider.notifier).refresh();
    }
  }

  void clearQuery() {
    state = '';
    ref.read(usersNotifierProvider.notifier).refresh();
  }
}

/// Provider for selected user
@riverpod
class SelectedUser extends _$SelectedUser {
  @override
  UserEntity? build() {
    return null;
  }

  void selectUser(UserEntity? user) {
    state = user;
  }

  void clearSelection() {
    state = null;
  }
}

/// Provider for user statistics
@riverpod
Future<UserStats> userStats(Ref ref) async {
  final users = await ref.watch(usersNotifierProvider.future);
  
  return UserStats(
    totalUsers: users.length,
    usersWithWebsite: users.where((u) => u.website != null && u.website!.isNotEmpty).length,
    usersWithCompany: users.where((u) => u.company != null).length,
    domainCounts: _calculateDomainCounts(users),
    companyCounts: _calculateCompanyCounts(users),
  );
}

/// Helper function to calculate email domain counts
Map<String, int> _calculateDomainCounts(List<UserEntity> users) {
  final domainCounts = <String, int>{};
  
  for (final user in users) {
    final domain = user.email.split('@').last.toLowerCase();
    domainCounts[domain] = (domainCounts[domain] ?? 0) + 1;
  }
  
  return domainCounts;
}

/// Helper function to calculate company counts
Map<String, int> _calculateCompanyCounts(List<UserEntity> users) {
  final companyCounts = <String, int>{};
  
  for (final user in users) {
    if (user.company != null) {
      final company = user.company!.name;
      companyCounts[company] = (companyCounts[company] ?? 0) + 1;
    }
  }
  
  return companyCounts;
}

/// User statistics data class
class UserStats {
  final int totalUsers;
  final int usersWithWebsite;
  final int usersWithCompany;
  final Map<String, int> domainCounts;
  final Map<String, int> companyCounts;

  const UserStats({
    required this.totalUsers,
    required this.usersWithWebsite,
    required this.usersWithCompany,
    required this.domainCounts,
    required this.companyCounts,
  });

  double get websitePercentage {
    if (totalUsers == 0) return 0.0;
    return (usersWithWebsite / totalUsers) * 100;
  }

  double get companyPercentage {
    if (totalUsers == 0) return 0.0;
    return (usersWithCompany / totalUsers) * 100;
  }

  String get mostCommonDomain {
    if (domainCounts.isEmpty) return 'N/A';
    return domainCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  String get mostCommonCompany {
    if (companyCounts.isEmpty) return 'N/A';
    return companyCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}