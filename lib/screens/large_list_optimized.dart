import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class LargeListOptimized extends StatefulWidget {
  const LargeListOptimized({super.key});

  @override
  State<LargeListOptimized> createState() => _LargeListOptimizedState();
}

class _LargeListOptimizedState extends State<LargeListOptimized> {
  final List<ListItem> _items = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String _searchQuery = '';
  List<ListItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _generateItems();
    _filteredItems = List.from(_items);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _generateItems() {
    setState(() {
      _isLoading = true;
    });

    // Simulate generating 1000 items
    Future.delayed(const Duration(milliseconds: 500), () {
      final random = math.Random();
      final names = ['Alice', 'Bob', 'Charlie', 'Diana', 'Edward', 'Fiona', 'George', 'Hannah'];
      final departments = ['Engineering', 'Marketing', 'Sales', 'HR', 'Finance', 'Operations'];
      final avatarColors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal];

      for (int i = 0; i < 1000; i++) {
        _items.add(ListItem(
          id: i,
          name: '${names[random.nextInt(names.length)]} ${i + 1}',
          email: 'user${i + 1}@company.com',
          department: departments[random.nextInt(departments.length)],
          avatarColor: avatarColors[random.nextInt(avatarColors.length)],
          salary: 50000 + random.nextInt(100000),
          joinDate: DateTime.now().subtract(Duration(days: random.nextInt(1095))),
        ));
      }

      setState(() {
        _isLoading = false;
        _filteredItems = List.from(_items);
      });
    });
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredItems = List.from(_items);
      } else {
        _filteredItems = _items
            .where((item) =>
                item.name.toLowerCase().contains(query.toLowerCase()) ||
                item.department.toLowerCase().contains(query.toLowerCase()) ||
                item.email.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Optimized Large List (1000 items)',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildStats(),
          Expanded(
            child: _isLoading ? _buildLoadingState() : _buildOptimizedList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.keyboard_arrow_up),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: _filterItems,
        decoration: InputDecoration(
          hintText: 'Search by name, department, or email...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _filterItems('');
                    // Clear the text field
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Showing ${_filteredItems.length} of ${_items.length} items',
              style: GoogleFonts.poppins(
                color: Colors.blue[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Filtered',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Generating 1000 items...'),
        ],
      ),
    );
  }

  Widget _buildOptimizedList() {
    return ListView.builder(
      controller: _scrollController,
      // Key optimizations for performance:
      itemExtent: 80.0, // Fixed height for better performance
      cacheExtent: 200.0, // Cache more items off-screen
      physics: const BouncingScrollPhysics(),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return _OptimizedListTile(
          key: ValueKey(item.id), // Important for widget recycling
          item: item,
          onTap: () => _showItemDetails(item),
        );
      },
    );
  }

  void _showItemDetails(ListItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          item.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.email, 'Email', item.email),
            _buildDetailRow(Icons.work, 'Department', item.department),
            _buildDetailRow(Icons.attach_money, 'Salary', '\$${item.salary}'),
            _buildDetailRow(Icons.calendar_today, 'Join Date', 
                '${item.joinDate.day}/${item.joinDate.month}/${item.joinDate.year}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}

// Optimized list tile widget
class _OptimizedListTile extends StatelessWidget {
  final ListItem item;
  final VoidCallback onTap;

  const _OptimizedListTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Fixed height for better performance
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: item.avatarColor,
                  radius: 20,
                  child: Text(
                    item.name[0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.email,
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.avatarColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.department,
                        style: GoogleFonts.poppins(
                          color: item.avatarColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${(item.salary / 1000).toStringAsFixed(0)}k',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Data model
class ListItem {
  final int id;
  final String name;
  final String email;
  final String department;
  final Color avatarColor;
  final int salary;
  final DateTime joinDate;

  ListItem({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.avatarColor,
    required this.salary,
    required this.joinDate,
  });
}