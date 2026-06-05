import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/backgrounds/modern_backgrounds.dart';
import '../core/constants/app_constants.dart';
import '../architecture/presentation/bloc/user_bloc.dart';
import '../architecture/presentation/bloc/user_event.dart';
import '../architecture/presentation/bloc/user_state.dart';
import '../architecture/domain/entities/user_entity.dart';
import '../services/di/injection.dart';

class BlocDemoScreen extends StatelessWidget {
  const BlocDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(getIt())..add(const LoadUsersEvent()),
      child: const BlocDemoView(),
    );
  }
}

class BlocDemoView extends StatefulWidget {
  const BlocDemoView({super.key});

  @override
  State<BlocDemoView> createState() => _BlocDemoViewState();
}

class _BlocDemoViewState extends State<BlocDemoView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BLoC Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UserBloc>().add(const RefreshUsersEvent());
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              context.read<UserBloc>().add(const ClearCacheEvent());
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              UserSortType? sortType;
              switch (value) {
                case 'name':
                  sortType = UserSortType.name;
                  break;
                case 'username':
                  sortType = UserSortType.username;
                  break;
                case 'email':
                  sortType = UserSortType.email;
                  break;
                case 'company':
                  sortType = UserSortType.company;
                  break;
              }
              if (sortType != null) {
                context.read<UserBloc>().add(SortUsersEvent(sortType));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'name', child: Text('Sort by Name')),
              const PopupMenuItem(value: 'username', child: Text('Sort by Username')),
              const PopupMenuItem(value: 'email', child: Text('Sort by Email')),
              const PopupMenuItem(value: 'company', child: Text('Sort by Company')),
            ],
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: ModernBackground(
        type: BackgroundType.galaxy,
        intensity: 0.4,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildSearchBar(context),
              _buildStatsSection(context),
              Expanded(
                child: _buildUsersList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_tree,
                color: AppColors.primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BLoC Pattern Demo',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Business Logic Component with events & states',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (query) {
            if (query.isNotEmpty) {
              context.read<UserBloc>().add(SearchUsersEvent(query));
            } else {
              context.read<UserBloc>().add(const ClearSearchEvent());
            }
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search users by name, username, or email...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      context.read<UserBloc>().add(const ClearSearchEvent());
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UsersLoaded && state.stats != null) {
            final stats = state.stats!;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    'Total Users',
                    stats.totalUsers.toString(),
                    Icons.people,
                    AppColors.primaryBlue,
                  ),
                  _buildStatItem(
                    context,
                    'With Website',
                    '${stats.websitePercentage.toStringAsFixed(0)}%',
                    Icons.web,
                    AppColors.primaryGreen,
                  ),
                  _buildStatItem(
                    context,
                    'With Company',
                    '${stats.companyPercentage.toStringAsFixed(0)}%',
                    Icons.business,
                    AppColors.primaryOrange,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildUsersList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<UserBloc>().add(const LoadUsersEvent(forceRefresh: true));
                  },
                ),
              ),
            );
          } else if (state is UserSyncComplete) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is UserCacheCleared) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cache cleared successfully'),
                backgroundColor: Colors.blue,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserInitial || state is UserLoading) {
            return _buildLoadingState(state);
          } else if (state is UsersLoaded) {
            return _buildUsersLoadedState(context, state);
          } else if (state is UserSearching) {
            return _buildSearchingState(state);
          } else if (state is UserSyncing) {
            return _buildSyncingState();
          } else if (state is UserError) {
            return _buildErrorState(context, state);
          }
          
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildLoadingState(UserState state) {
    String message = 'Loading users...';
    if (state is UserLoading && state.message != null) {
      message = state.message!;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersLoadedState(BuildContext context, UsersLoaded state) {
    final displayUsers = state.displayUsers;
    
    if (displayUsers.isEmpty) {
      return _buildEmptyState(context, state.isSearching);
    }

    return ListView.builder(
      itemCount: displayUsers.length,
      itemBuilder: (context, index) {
        final user = displayUsers[index];
        return _buildUserCard(context, user, state.selectedUser?.id == user.id);
      },
    );
  }

  Widget _buildSearchingState(UserSearching state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 16),
          Text(
            'Searching for "${state.query}"...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 16),
          Text(
            'Syncing users...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, UserError state) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            if (state.details != null) ...[
              const SizedBox(height: 8),
              Text(
                state.details!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.red.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<UserBloc>().add(const LoadUsersEvent(forceRefresh: true));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isSearching) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.people_outline,
              size: 64,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'No users found' : 'No users available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching 
                ? 'Try adjusting your search query'
                : 'Tap refresh to load users',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserEntity user, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<UserBloc>().add(
              SelectUserEvent(isSelected ? null : user),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryBlue.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryBlue.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.2),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${user.username}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primaryBlue,
                        size: 24,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
                if (user.website != null && user.website!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.web,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          user.website!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (user.company != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          user.company!.name,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}