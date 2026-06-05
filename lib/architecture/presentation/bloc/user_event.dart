import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Base class for all user events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all users
class LoadUsersEvent extends UserEvent {
  final bool forceRefresh;

  const LoadUsersEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

/// Event to search users
class SearchUsersEvent extends UserEvent {
  final String query;

  const SearchUsersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to clear search
class ClearSearchEvent extends UserEvent {
  const ClearSearchEvent();
}

/// Event to refresh users
class RefreshUsersEvent extends UserEvent {
  const RefreshUsersEvent();
}

/// Event to select a user
class SelectUserEvent extends UserEvent {
  final UserEntity? user;

  const SelectUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

/// Event to clear user selection
class ClearUserSelectionEvent extends UserEvent {
  const ClearUserSelectionEvent();
}

/// Event to load user by ID
class LoadUserByIdEvent extends UserEvent {
  final int userId;

  const LoadUserByIdEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Event to clear cache
class ClearCacheEvent extends UserEvent {
  const ClearCacheEvent();
}

/// Event to sync users
class SyncUsersEvent extends UserEvent {
  const SyncUsersEvent();
}

/// Event to filter users by domain
class FilterUsersByDomainEvent extends UserEvent {
  final String domain;

  const FilterUsersByDomainEvent(this.domain);

  @override
  List<Object?> get props => [domain];
}

/// Event to sort users
class SortUsersEvent extends UserEvent {
  final UserSortType sortType;

  const SortUsersEvent(this.sortType);

  @override
  List<Object?> get props => [sortType];
}

/// Enum for user sort types
enum UserSortType {
  name,
  username,
  email,
  company,
}