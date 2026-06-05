import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Base class for all user states
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class UserInitial extends UserState {
  const UserInitial();
}

/// Loading state
class UserLoading extends UserState {
  final String? message;

  const UserLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when users are loaded successfully
class UsersLoaded extends UserState {
  final List<UserEntity> users;
  final List<UserEntity> filteredUsers;
  final String searchQuery;
  final UserEntity? selectedUser;
  final UserStats? stats;
  final bool isSearching;

  const UsersLoaded({
    required this.users,
    this.filteredUsers = const [],
    this.searchQuery = '',
    this.selectedUser,
    this.stats,
    this.isSearching = false,
  });

  /// Get the list to display (filtered users if searching, otherwise all users)
  List<UserEntity> get displayUsers => isSearching ? filteredUsers : users;

  UsersLoaded copyWith({
    List<UserEntity>? users,
    List<UserEntity>? filteredUsers,
    String? searchQuery,
    UserEntity? selectedUser,
    UserStats? stats,
    bool? isSearching,
    bool clearSelectedUser = false,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedUser: clearSelectedUser ? null : (selectedUser ?? this.selectedUser),
      stats: stats ?? this.stats,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
        users,
        filteredUsers,
        searchQuery,
        selectedUser,
        stats,
        isSearching,
      ];
}

/// State when user loading fails
class UserError extends UserState {
  final String message;
  final String? details;

  const UserError(this.message, {this.details});

  @override
  List<Object?> get props => [message, details];
}

/// State when searching for users
class UserSearching extends UserState {
  final String query;

  const UserSearching(this.query);

  @override
  List<Object?> get props => [query];
}

/// State when a specific user is loaded
class UserDetailLoaded extends UserState {
  final UserEntity user;

  const UserDetailLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when syncing users
class UserSyncing extends UserState {
  const UserSyncing();
}

/// State when sync is complete
class UserSyncComplete extends UserState {
  final String message;

  const UserSyncComplete(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when cache is cleared
class UserCacheCleared extends UserState {
  const UserCacheCleared();
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