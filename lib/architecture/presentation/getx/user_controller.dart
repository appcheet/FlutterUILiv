import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';

/// GetX controller for managing user state with reactive programming
class UserController extends GetxController {
  final GetUsersUseCase _getUsersUseCase;

  UserController(this._getUsersUseCase);

  // Reactive variables
  final RxList<UserEntity> _users = <UserEntity>[].obs;
  final RxList<UserEntity> _filteredUsers = <UserEntity>[].obs;
  final Rxn<UserEntity> _selectedUser = Rxn<UserEntity>();
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isSearching = false.obs;
  final RxString _errorMessage = ''.obs;
  final Rxn<UserStats> _stats = Rxn<UserStats>();

  // Getters for reactive variables
  RxList<UserEntity> get users => _users;
  RxList<UserEntity> get filteredUsers => _filteredUsers;
  List<UserEntity> get displayUsers => _isSearching.value ? _filteredUsers : _users;
  Rxn<UserEntity> get selectedUser => _selectedUser;
  RxString get searchQuery => _searchQuery;
  RxBool get isLoading => _isLoading;
  RxBool get isSearching => _isSearching;
  RxString get errorMessage => _errorMessage;
  Rxn<UserStats> get stats => _stats;

  // Computed properties
  bool get hasUsers => _users.isNotEmpty;
  bool get hasError => _errorMessage.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  /// Load users from the use case
  Future<void> loadUsers({bool forceRefresh = false}) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _getUsersUseCase.execute(forceRefresh: forceRefresh);
      
      result.fold(
        (error) => _setError('Failed to load users: $error'),
        (usersList) {
          _users.assignAll(usersList);
          _updateStats();
          _setLoading(false);
        },
      );
    } catch (e) {
      _setError('Unexpected error: ${e.toString()}');
    }
  }

  /// Refresh users (force reload from remote)
  Future<void> refreshUsers() async {
    await loadUsers(forceRefresh: true);
    clearSearch();
  }

  /// Search for users
  Future<void> searchUsers(String query) async {
    _searchQuery.value = query.trim();
    
    if (_searchQuery.value.isEmpty) {
      clearSearch();
      return;
    }

    _setSearching(true);
    _clearError();

    try {
      final result = await _getUsersUseCase.searchUsers(_searchQuery.value);
      
      result.fold(
        (error) => _setError('Search failed: $error'),
        (usersList) {
          _filteredUsers.assignAll(usersList);
          _setSearching(false, keepSearchState: true);
        },
      );
    } catch (e) {
      _setError('Search error: ${e.toString()}');
    }
  }

  /// Clear search and show all users
  void clearSearch() {
    _searchQuery.value = '';
    _isSearching.value = false;
    _filteredUsers.clear();
  }

  /// Select a user
  void selectUser(UserEntity? user) {
    _selectedUser.value = user;
  }

  /// Clear user selection
  void clearUserSelection() {
    _selectedUser.value = null;
  }

  /// Get user by ID
  Future<UserEntity?> getUserById(int id) async {
    try {
      final result = await _getUsersUseCase.getUserById(id);
      return result.fold(
        (error) {
          _setError('Failed to get user: $error');
          return null;
        },
        (user) => user,
      );
    } catch (e) {
      _setError('Get user error: ${e.toString()}');
      return null;
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _getUsersUseCase.clearCache();
      
      result.fold(
        (error) => _setError('Failed to clear cache: $error'),
        (success) {
          if (success) {
            _users.clear();
            _filteredUsers.clear();
            _selectedUser.value = null;
            clearSearch();
            _updateStats();
            // Show success message
            if (Get.context != null) {
              try {
                Get.snackbar(
                  'Cache Cleared',
                  'Cache cleared successfully',
                  backgroundColor: Get.theme.primaryColor.withValues(alpha: 0.8),
                  colorText: Get.theme.colorScheme.onPrimary,
                );
              } catch (e) {
                // Silently handle snackbar errors
              }
            }
            // Reload users after clearing cache
            loadUsers(forceRefresh: true);
          } else {
            _setError('Failed to clear cache');
          }
        },
      );
    } catch (e) {
      _setError('Cache clear error: ${e.toString()}');
    }
  }

  /// Sync users with remote
  Future<void> syncUsers() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _getUsersUseCase.syncUsers();
      
      result.fold(
        (error) => _setError('Sync failed: $error'),
        (success) {
          if (success) {
            // Show success message
            if (Get.context != null) {
              try {
                Get.snackbar(
                  'Sync Complete',
                  'Users synced successfully',
                  backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.8),
                  colorText: Get.theme.colorScheme.onPrimary,
                );
              } catch (e) {
                // Silently handle snackbar errors
              }
            }
            // Reload users after successful sync
            loadUsers(forceRefresh: true);
          } else {
            _setError('Sync failed');
          }
        },
      );
    } catch (e) {
      _setError('Sync error: ${e.toString()}');
    }
  }

  /// Filter users by domain
  void filterUsersByDomain(String domain) {
    if (_users.isEmpty) {
      _setError('No users to filter');
      return;
    }

    final filtered = _users
        .where((user) => user.email.toLowerCase().contains('@${domain.toLowerCase()}'))
        .toList();
    
    _filteredUsers.assignAll(filtered);
    _searchQuery.value = 'Domain: $domain';
    _isSearching.value = true;
    _clearError();
  }

  /// Sort users by different criteria
  void sortUsers(UserSortType sortType) {
    if (_users.isEmpty) {
      _setError('No users to sort');
      return;
    }

    final sortedUsers = List<UserEntity>.from(_users);
    
    switch (sortType) {
      case UserSortType.name:
        sortedUsers.sort((a, b) => a.name.compareTo(b.name));
        break;
      case UserSortType.username:
        sortedUsers.sort((a, b) => a.username.compareTo(b.username));
        break;
      case UserSortType.email:
        sortedUsers.sort((a, b) => a.email.compareTo(b.email));
        break;
      case UserSortType.company:
        sortedUsers.sort((a, b) {
          final aCompany = a.company?.name ?? '';
          final bCompany = b.company?.name ?? '';
          return aCompany.compareTo(bCompany);
        });
        break;
    }
    
    _users.assignAll(sortedUsers);
    _updateStats();
  }

  /// Get users with website
  List<UserEntity> getUsersWithWebsite() {
    return _users.where((user) => user.website != null && user.website!.isNotEmpty).toList();
  }

  /// Get users with company
  List<UserEntity> getUsersWithCompany() {
    return _users.where((user) => user.company != null).toList();
  }

  /// Filter users by email domain
  List<UserEntity> filterByEmailDomain(String domain) {
    return _users.where((user) => user.email.endsWith('@$domain')).toList();
  }

  /// Toggle user selection (for multi-select scenarios)
  void toggleUserSelection(UserEntity user) {
    if (_selectedUser.value?.id == user.id) {
      _selectedUser.value = null;
    } else {
      _selectedUser.value = user;
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading.value = loading;
    if (!loading) _clearError();
  }

  void _setSearching(bool searching, {bool keepSearchState = false}) {
    _isLoading.value = false;
    _isSearching.value = searching;
    if (!keepSearchState) {
      _isSearching.value = false;
    }
  }

  void _setError(String error) {
    _errorMessage.value = error;
    _isLoading.value = false;
    _isSearching.value = false;
    
    // Show error snackbar only if context is available
    if (error.isNotEmpty && Get.context != null) {
      try {
        Get.snackbar(
          'Error',
          error,
          backgroundColor: Get.theme.colorScheme.error.withValues(alpha: 0.8),
          colorText: Get.theme.colorScheme.onError,
          duration: const Duration(seconds: 4),
        );
      } catch (e) {
        // Silently handle snackbar errors to prevent crashes
        // Snackbar error ignored
      }
    }
  }

  void _clearError() {
    _errorMessage.value = '';
  }

  void _updateStats() {
    if (_users.isNotEmpty) {
      _stats.value = UserStats.fromUsers(_users);
    } else {
      _stats.value = null;
    }
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}

/// Enum for user sort types
enum UserSortType {
  name,
  username,
  email,
  company,
}

/// User statistics data class for GetX
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

  factory UserStats.fromUsers(List<UserEntity> users) {
    final domainCounts = <String, int>{};
    final companyCounts = <String, int>{};
    
    int usersWithWebsite = 0;
    int usersWithCompany = 0;
    
    for (final user in users) {
      // Count domains
      final domain = user.email.split('@').last.toLowerCase();
      domainCounts[domain] = (domainCounts[domain] ?? 0) + 1;
      
      // Count websites
      if (user.website != null && user.website!.isNotEmpty) {
        usersWithWebsite++;
      }
      
      // Count companies
      if (user.company != null) {
        usersWithCompany++;
        final company = user.company!.name;
        companyCounts[company] = (companyCounts[company] ?? 0) + 1;
      }
    }
    
    return UserStats(
      totalUsers: users.length,
      usersWithWebsite: usersWithWebsite,
      usersWithCompany: usersWithCompany,
      domainCounts: domainCounts,
      companyCounts: companyCounts,
    );
  }
}