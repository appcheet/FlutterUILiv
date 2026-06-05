import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/backgrounds/modern_backgrounds.dart';
import '../core/constants/app_constants.dart';
import '../architecture/presentation/provider/user_provider.dart';
import '../architecture/domain/entities/user_entity.dart';
import '../services/di/injection.dart';

class ProviderDemoScreen extends StatelessWidget {
  const ProviderDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(getIt())..loadUsers(),
      child: const ProviderDemoView(),
    );
  }
}

class ProviderDemoView extends StatefulWidget {
  const ProviderDemoView({super.key});

  @override
  State<ProviderDemoView> createState() => _ProviderDemoViewState();
}

class _ProviderDemoViewState extends State<ProviderDemoView> {
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
          'Provider Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UserProvider>().refreshUsers();
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              context.read<UserProvider>().clearCache();
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: ModernBackground(
        type: BackgroundType.ocean,
        intensity: 0.4,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildStatsSection(),
              Expanded(
                child: _buildUsersList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                color: AppColors.primaryOrange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.layers,
                color: AppColors.primaryOrange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Provider Pattern Demo',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Simple and intuitive state management',
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

  Widget _buildSearchBar() {
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
              context.read<UserProvider>().searchUsers(query);
            } else {
              context.read<UserProvider>().clearSearch();
            }
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            suffixIcon: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return userProvider.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          context.read<UserProvider>().clearSearch();
                        },
                      )
                    : const SizedBox.shrink();
              },
            ),
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

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.stats != null) {
            final stats = userProvider.stats!;
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
                    'Total',
                    stats.totalUsers.toString(),
                    Icons.people,
                    AppColors.primaryBlue,
                  ),
                  _buildStatItem(
                    'Website',
                    '${stats.websitePercentage.toStringAsFixed(0)}%',
                    Icons.web,
                    AppColors.primaryGreen,
                  ),
                  _buildStatItem(
                    'Company',
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

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
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

  Widget _buildUsersList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
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

          if (userProvider.hasUsers) {
            final displayUsers = userProvider.displayUsers;
            return ListView.builder(
              itemCount: displayUsers.length,
              itemBuilder: (context, index) {
                final user = displayUsers[index];
                return _buildUserCard(user, userProvider.selectedUser?.id == user.id);
              },
            );
          }

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
                    Icons.people_outline,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No users available',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap refresh to load users',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserCard(UserEntity user, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<UserProvider>().selectUser(isSelected ? null : user);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryOrange.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryOrange.withValues(alpha: 0.5)
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
                      backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.2),
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primaryOrange,
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
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primaryOrange,
                        size: 24,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                if (user.company != null)
                  Text(
                    user.company!.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}