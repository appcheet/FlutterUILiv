import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';

/// Provider for managing user state using ChangeNotifier
class UserProvider extends ChangeNotifier {
  final GetUsersUseCase _getUsersUseCase;

  UserProvider(this._getUsersUseCase);

  // Private state variables
  List<UserEntity> _users = [];
  List<UserEntity> _filteredUsers = [];
  UserEntity? _selectedUser;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  UserStats? _stats;

  // Public getters
  List<UserEntity> get users => List.unmodifiable(_users);
  List<UserEntity> get filteredUsers => List.unmodifiable(_filteredUsers);
  List<UserEntity> get displayUsers => _isSearching ? _filteredUsers : _users;
  UserEntity? get selectedUser => _selectedUser;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  UserStats? get stats => _stats;
  bool get hasUsers => _users.isNotEmpty;
  bool get hasError => _errorMessage != null;

  /// Load users from the use case
  Future<void> loadUsers({bool forceRefresh = false}) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _getUsersUseCase.execute(forceRefresh: forceRefresh);
      
      result.fold(
        (error) => _setError('Failed to load users: $error'),
        (users) {
          _users = users;
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
    _clearSearch();
  }

  /// Search for users
  Future<void> searchUsers(String query) async {
    _searchQuery = query.trim();
    
    if (_searchQuery.isEmpty) {
      _clearSearch();
      return;
    }

    _setSearching(true);
    _clearError();

    try {
      final result = await _getUsersUseCase.searchUsers(_searchQuery);
      
      result.fold(
        (error) => _setError('Search failed: $error'),
        (users) {
          _filteredUsers = users;
          _setSearching(false, keepSearchState: true);
        },
      );
    } catch (e) {
      _setError('Search error: ${e.toString()}');
    }
  }

  /// Clear search and show all users
  void clearSearch() {
    _clearSearch();
  }

  /// Select a user
  void selectUser(UserEntity? user) {
    _selectedUser = user;
    notifyListeners();
  }

  /// Clear user selection
  void clearUserSelection() {
    _selectedUser = null;
    notifyListeners();
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
            _selectedUser = null;
            _clearSearch();
            _updateStats();
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

    _filteredUsers = _users
        .where((user) => user.email.toLowerCase().contains('@${domain.toLowerCase()}'))
        .toList();
    
    _searchQuery = 'Domain: $domain';
    _isSearching = true;
    _clearError();
    notifyListeners();
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
    
    _users = sortedUsers;
    _updateStats();
    notifyListeners();
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

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (!loading) _clearError();
    notifyListeners();
  }

  void _setSearching(bool searching, {bool keepSearchState = false}) {
    _isLoading = false;
    _isSearching = searching;
    if (!keepSearchState) {
      _isSearching = false;
    }
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    _isSearching = false;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    _filteredUsers.clear();
    notifyListeners();
  }

  void _updateStats() {
    if (_users.isNotEmpty) {
      _stats = UserStats.fromUsers(_users);
    } else {
      _stats = null;
    }
  }

}

/// Enum for user sort types
enum UserSortType {
  name,
  username,
  email,
  company,
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