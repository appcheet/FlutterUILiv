import 'package:flutter/material.dart';
import '../shared/backgrounds/modern_backgrounds.dart';
import '../core/constants/app_constants.dart';
import '../architecture/domain/entities/user_entity.dart';
import '../services/data/large_data_service.dart';

class LargeListPaginationScreen extends StatefulWidget {
  const LargeListPaginationScreen({super.key});

  @override
  State<LargeListPaginationScreen> createState() => _LargeListPaginationScreenState();
}

class _LargeListPaginationScreenState extends State<LargeListPaginationScreen> {
  static const int _pageSize = 20;
  
  List<UserEntity> _users = [];
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isLoading = false;
  bool _hasError = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _totalPages = LargeDataService.getTotalPages(_pageSize);
    _loadPage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPage() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      List<UserEntity> users;
      if (_searchQuery.isEmpty) {
        users = await LargeDataService.generateUsersPage(
          page: _currentPage,
          pageSize: _pageSize,
        );
      } else {
        users = await LargeDataService.searchUsersPage(
          query: _searchQuery,
          page: _currentPage,
          pageSize: _pageSize,
        );
      }

      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _search(String query) async {
    setState(() {
      _searchQuery = query;
      _currentPage = 1; // Reset to first page on search
    });
    await _loadPage();
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages && page != _currentPage) {
      setState(() {
        _currentPage = page;
      });
      _loadPage();
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      _goToPage(_currentPage + 1);
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _goToPage(_currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pagination Example',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPage,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: ModernBackground(
        type: BackgroundType.gradientBlur,
        intensity: 0.3,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildPaginationInfo(),
              Expanded(
                child: _buildUsersList(),
              ),
              _buildPaginationControls(),
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
                color: AppColors.primaryBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.view_list,
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
                    'Pagination Demo',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Efficiently loading large datasets (1000+ items)',
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
          onSubmitted: _search,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search users...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _search('');
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    onPressed: () => _search(_searchController.text),
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

  Widget _buildPaginationInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Page',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  '$_currentPage of $_totalPages',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Items',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  '${_users.length}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  '${LargeDataService.getTotalUserCount()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Loading users...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load users',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadPage,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_users.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(UserEntity user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
          child: Text(
            user.name.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
            if (user.company != null)
              Text(
                user.company!.name,
                style: TextStyle(color: AppColors.primaryGreen.withValues(alpha: 0.8)),
              ),
          ],
        ),
        trailing: Text(
          '#${user.id}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          ElevatedButton.icon(
            onPressed: _currentPage > 1 ? _previousPage : null,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Previous'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.8),
              foregroundColor: Colors.white,
            ),
          ),
          
          // Page numbers
          Expanded(
            child: Center(
              child: Wrap(
                spacing: 8,
                children: _buildPageNumbers(),
              ),
            ),
          ),
          
          // Next button
          ElevatedButton.icon(
            onPressed: _currentPage < _totalPages ? _nextPage : null,
            icon: const Icon(Icons.chevron_right),
            label: const Text('Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.8),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    final pages = <Widget>[];
    const maxVisiblePages = 5;
    
    int startPage = (_currentPage - maxVisiblePages ~/ 2).clamp(1, _totalPages);
    int endPage = (startPage + maxVisiblePages - 1).clamp(1, _totalPages);
    
    // Adjust start if we're near the end
    if (endPage - startPage < maxVisiblePages - 1) {
      startPage = (endPage - maxVisiblePages + 1).clamp(1, _totalPages);
    }
    
    for (int i = startPage; i <= endPage; i++) {
      pages.add(
        GestureDetector(
          onTap: () => _goToPage(i),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: i == _currentPage 
                ? AppColors.primaryOrange 
                : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: i == _currentPage 
                  ? AppColors.primaryOrange 
                  : Colors.white.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              i.toString(),
              style: TextStyle(
                color: i == _currentPage ? Colors.white : Colors.white.withValues(alpha: 0.8),
                fontWeight: i == _currentPage ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }
    
    return pages;
  }
}