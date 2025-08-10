import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shared/backgrounds/modern_backgrounds.dart';
import '../core/constants/app_constants.dart';
import '../architecture/presentation/getx/user_controller.dart';
import '../architecture/presentation/getx/user_binding.dart';
import '../architecture/domain/entities/user_entity.dart';

class GetXDemoScreen extends StatelessWidget {
  const GetXDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize bindings manually since we're not using GetX routing
    UserManualBinding.init();
    
    return const GetXDemoView();
  }
}

class GetXDemoView extends StatefulWidget {
  const GetXDemoView({super.key});

  @override
  State<GetXDemoView> createState() => _GetXDemoViewState();
}

class _GetXDemoViewState extends State<GetXDemoView> {
  final TextEditingController _searchController = TextEditingController();
  final UserController userController = Get.find<UserController>();

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
          'GetX Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => userController.refreshUsers(),
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => userController.clearCache(),
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
                userController.sortUsers(sortType);
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
        type: BackgroundType.neon,
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
                color: AppColors.primaryPurple.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.flash_on,
                color: AppColors.primaryPurple,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GetX Pattern Demo',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Reactive programming with GetX controllers',
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
              userController.searchUsers(query);
            } else {
              userController.clearSearch();
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
            suffixIcon: Obx(() {
              return userController.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      onPressed: () {
                        _searchController.clear();
                        userController.clearSearch();
                      },
                    )
                  : const SizedBox.shrink();
            }),
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
      child: Obx(() {
        final stats = userController.stats.value;
        if (stats != null) {
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
                  AppColors.primaryPurple,
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
      }),
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
      child: Obx(() {
        // Handle loading state
        if (userController.isLoading.value) {
          return _buildLoadingState();
        }

        // Handle users loaded state
        if (userController.hasUsers) {
          return _buildUsersLoadedState(context);
        }

        // Handle empty state
        return _buildEmptyState(context);
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading users...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersLoadedState(BuildContext context) {
    return Obx(() {
      final displayUsers = userController.displayUsers;
      
      if (displayUsers.isEmpty) {
        return _buildEmptyState(context, isSearching: userController.isSearching.value);
      }

      return ListView.builder(
        itemCount: displayUsers.length,
        itemBuilder: (context, index) {
          final user = displayUsers[index];
          return Obx(() {
            final isSelected = userController.selectedUser.value?.id == user.id;
            return _buildUserCard(context, user, isSelected);
          });
        },
      );
    });
  }

  Widget _buildEmptyState(BuildContext context, {bool isSearching = false}) {
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
            if (!isSearching) ...[ 
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => userController.loadUsers(forceRefresh: true),
                child: const Text('Load Users'),
              ),
            ],
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
          onTap: () => userController.selectUser(isSelected ? null : user),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryPurple.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryPurple.withValues(alpha: 0.5)
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
                      backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.2),
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primaryPurple,
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
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primaryPurple,
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