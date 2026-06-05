import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

/// BLoC for managing user-related state
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersUseCase _getUsersUseCase;
  
  // Internal state
  List<UserEntity> _allUsers = [];
  UserEntity? _selectedUser;
  String _currentSearchQuery = '';

  UserBloc(this._getUsersUseCase) : super(const UserInitial()) {
    // Register event handlers
    on<LoadUsersEvent>(_onLoadUsers);
    on<RefreshUsersEvent>(_onRefreshUsers);
    on<SearchUsersEvent>(_onSearchUsers);
    on<ClearSearchEvent>(_onClearSearch);
    on<SelectUserEvent>(_onSelectUser);
    on<ClearUserSelectionEvent>(_onClearUserSelection);
    on<LoadUserByIdEvent>(_onLoadUserById);
    on<ClearCacheEvent>(_onClearCache);
    on<SyncUsersEvent>(_onSyncUsers);
    on<FilterUsersByDomainEvent>(_onFilterUsersByDomain);
    on<SortUsersEvent>(_onSortUsers);
  }

  /// Handle loading users
  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading(message: 'Loading users...'));
    
    try {
      final result = await _getUsersUseCase.execute(forceRefresh: event.forceRefresh);
      
      result.fold(
        (error) => emit(UserError('Failed to load users: $error')),
        (users) {
          _allUsers = users;
          _emitUsersLoadedState(emit);
        },
      );
    } catch (e) {
      emit(UserError('Unexpected error: ${e.toString()}'));
    }
  }

  /// Handle refreshing users
  Future<void> _onRefreshUsers(
    RefreshUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading(message: 'Refreshing users...'));
    
    try {
      final result = await _getUsersUseCase.execute(forceRefresh: true);
      
      result.fold(
        (error) => emit(UserError('Failed to refresh users: $error')),
        (users) {
          _allUsers = users;
          _currentSearchQuery = ''; // Clear search on refresh
          _emitUsersLoadedState(emit);
        },
      );
    } catch (e) {
      emit(UserError('Unexpected error: ${e.toString()}'));
    }
  }

  /// Handle searching users
  Future<void> _onSearchUsers(
    SearchUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    final query = event.query.trim();
    _currentSearchQuery = query;
    
    if (query.isEmpty) {
      _emitUsersLoadedState(emit);
      return;
    }

    emit(UserSearching(query));
    
    try {
      final result = await _getUsersUseCase.searchUsers(query);
      
      result.fold(
        (error) => emit(UserError('Search failed: $error')),
        (users) {
          final filteredUsers = users;
          _emitUsersLoadedState(emit, filteredUsers: filteredUsers, isSearching: true);
        },
      );
    } catch (e) {
      emit(UserError('Search error: ${e.toString()}'));
    }
  }

  /// Handle clearing search
  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<UserState> emit,
  ) {
    _currentSearchQuery = '';
    _emitUsersLoadedState(emit);
  }

  /// Handle selecting a user
  void _onSelectUser(
    SelectUserEvent event,
    Emitter<UserState> emit,
  ) {
    _selectedUser = event.user;
    _emitUsersLoadedState(emit);
  }

  /// Handle clearing user selection
  void _onClearUserSelection(
    ClearUserSelectionEvent event,
    Emitter<UserState> emit,
  ) {
    _selectedUser = null;
    _emitUsersLoadedState(emit);
  }

  /// Handle loading user by ID
  Future<void> _onLoadUserById(
    LoadUserByIdEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading(message: 'Loading user details...'));
    
    try {
      final result = await _getUsersUseCase.getUserById(event.userId);
      
      result.fold(
        (error) => emit(UserError('Failed to load user: $error')),
        (user) {
          if (user != null) {
            emit(UserDetailLoaded(user));
          } else {
            emit(const UserError('User not found'));
          }
        },
      );
    } catch (e) {
      emit(UserError('Unexpected error: ${e.toString()}'));
    }
  }

  /// Handle clearing cache
  Future<void> _onClearCache(
    ClearCacheEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading(message: 'Clearing cache...'));
    
    try {
      final result = await _getUsersUseCase.clearCache();
      
      result.fold(
        (error) => emit(UserError('Failed to clear cache: $error')),
        (success) {
          if (success) {
            _allUsers.clear();
            _selectedUser = null;
            _currentSearchQuery = '';
            emit(const UserCacheCleared());
            // Reload users after clearing cache
            add(const LoadUsersEvent(forceRefresh: true));
          } else {
            emit(const UserError('Failed to clear cache'));
          }
        },
      );
    } catch (e) {
      emit(UserError('Cache clear error: ${e.toString()}'));
    }
  }

  /// Handle syncing users
  Future<void> _onSyncUsers(
    SyncUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserSyncing());
    
    try {
      final result = await _getUsersUseCase.syncUsers();
      
      result.fold(
        (error) => emit(UserError('Sync failed: $error')),
        (success) {
          if (success) {
            emit(const UserSyncComplete('Users synced successfully'));
            // Reload users after sync
            add(const LoadUsersEvent(forceRefresh: true));
          } else {
            emit(const UserError('Sync failed'));
          }
        },
      );
    } catch (e) {
      emit(UserError('Sync error: ${e.toString()}'));
    }
  }

  /// Handle filtering users by domain
  void _onFilterUsersByDomain(
    FilterUsersByDomainEvent event,
    Emitter<UserState> emit,
  ) {
    if (_allUsers.isEmpty) {
      emit(const UserError('No users to filter'));
      return;
    }

    final filteredUsers = _allUsers
        .where((user) => user.email.toLowerCase().contains('@${event.domain.toLowerCase()}'))
        .toList();
    
    _emitUsersLoadedState(emit, filteredUsers: filteredUsers, isSearching: true);
  }

  /// Handle sorting users
  void _onSortUsers(
    SortUsersEvent event,
    Emitter<UserState> emit,
  ) {
    if (_allUsers.isEmpty) {
      emit(const UserError('No users to sort'));
      return;
    }

    final sortedUsers = List<UserEntity>.from(_allUsers);
    
    switch (event.sortType) {
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
    
    _allUsers = sortedUsers;
    _emitUsersLoadedState(emit);
  }

  /// Helper method to emit UsersLoaded state with current data
  void _emitUsersLoadedState(
    Emitter<UserState> emit, {
    List<UserEntity>? filteredUsers,
    bool isSearching = false,
  }) {
    final stats = UserStats.fromUsers(_allUsers);
    
    emit(UsersLoaded(
      users: _allUsers,
      filteredUsers: filteredUsers ?? [],
      searchQuery: _currentSearchQuery,
      selectedUser: _selectedUser,
      stats: stats,
      isSearching: isSearching || _currentSearchQuery.isNotEmpty,
    ));
  }

  /// Get currently selected user
  UserEntity? get selectedUser => _selectedUser;
  
  /// Get current search query
  String get currentSearchQuery => _currentSearchQuery;
  
  /// Get all users
  List<UserEntity> get allUsers => List.unmodifiable(_allUsers);
}