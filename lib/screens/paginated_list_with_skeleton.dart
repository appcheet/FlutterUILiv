import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class PaginatedListWithSkeleton extends StatefulWidget {
  const PaginatedListWithSkeleton({super.key});

  @override
  State<PaginatedListWithSkeleton> createState() => _PaginatedListWithSkeletonState();
}

class _PaginatedListWithSkeletonState extends State<PaginatedListWithSkeleton> {
  final List<Product> _products = [];
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMoreData) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isInitialLoading = true;
    });

    await _simulateNetworkCall();
    
    final newProducts = _generateProducts(1, _itemsPerPage);
    
    setState(() {
      _products.clear();
      _products.addAll(newProducts);
      _currentPage = 1;
      _hasMoreData = _products.length == _itemsPerPage;
      _isInitialLoading = false;
    });
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    await _simulateNetworkCall();
    
    final newProducts = _generateProducts(_currentPage + 1, _itemsPerPage);
    
    setState(() {
      _products.addAll(newProducts);
      _currentPage++;
      _hasMoreData = newProducts.length == _itemsPerPage && _products.length < 500; // Simulate finite data
      _isLoading = false;
    });
  }

  Future<void> _simulateNetworkCall() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 800 + math.Random().nextInt(1200)));
  }

  List<Product> _generateProducts(int page, int count) {
    final random = math.Random();
    final categories = ['Electronics', 'Clothing', 'Books', 'Home & Garden', 'Sports', 'Beauty'];
    final brands = ['Apple', 'Samsung', 'Nike', 'Adidas', 'Sony', 'Microsoft', 'Google', 'Amazon'];
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal];

    List<Product> products = [];
    
    for (int i = 0; i < count; i++) {
      final productId = ((page - 1) * count) + i + 1;
      products.add(Product(
        id: productId,
        name: 'Product $productId',
        description: 'High-quality product with excellent features and modern design.',
        price: (random.nextDouble() * 500 + 10).round().toDouble(),
        category: categories[random.nextInt(categories.length)],
        brand: brands[random.nextInt(brands.length)],
        rating: (random.nextDouble() * 2 + 3).toDouble(), // 3.0 to 5.0
        reviews: random.nextInt(1000) + 10,
        imageColor: colors[random.nextInt(colors.length)],
        inStock: random.nextBool(),
        discount: random.nextBool() ? random.nextInt(50) + 5 : 0,
      ));
    }
    
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Paginated List with Skeleton',
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
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isInitialLoading 
          ? _buildSkeletonList() 
          : RefreshIndicator(
              onRefresh: _refresh,
              child: _buildProductList(),
            ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10, // Show 10 skeleton items
      itemBuilder: (context, index) => _buildSkeletonItem(),
    );
  }

  Widget _buildSkeletonItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Product image skeleton
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SkeletonBox(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name skeleton
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const SkeletonBox(),
                    ),
                    const SizedBox(height: 8),
                    // Brand skeleton
                    Container(
                      height: 14,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const SkeletonBox(),
                    ),
                    const SizedBox(height: 8),
                    // Price skeleton
                    Container(
                      height: 20,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const SkeletonBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description skeleton
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const SkeletonBox(),
          ),
          const SizedBox(height: 4),
          Container(
            height: 12,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const SkeletonBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _products.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _products.length) {
          return _buildLoadingIndicator();
        }
        return _buildProductItem(_products[index]);
      },
    );
  }

  Widget _buildProductItem(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showProductDetails(product),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Product image placeholder
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: product.imageColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: product.imageColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        color: product.imageColor,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (product.discount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${product.discount}% OFF',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.brand,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.green[700],
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (!product.inStock)
                                Text(
                                  'Out of Stock',
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  product.description,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 13,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: product.imageColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        product.category,
                        style: GoogleFonts.poppins(
                          color: product.imageColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          ' (${product.reviews})',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return _isLoading
        ? Container(
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : const SizedBox.shrink();
  }

  Future<void> _refresh() async {
    await _loadInitialData();
  }

  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          product.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Brand: ${product.brand}'),
            Text('Category: ${product.category}'),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            Text('Rating: ${product.rating.toStringAsFixed(1)} (${product.reviews} reviews)'),
            Text('Stock: ${product.inStock ? "In Stock" : "Out of Stock"}'),
            if (product.discount > 0) 
              Text('Discount: ${product.discount}% OFF'),
            const SizedBox(height: 8),
            Text(product.description),
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
}

// Skeleton loading widget
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({super.key});

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}

// Product model
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String brand;
  final double rating;
  final int reviews;
  final Color imageColor;
  final bool inStock;
  final int discount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.brand,
    required this.rating,
    required this.reviews,
    required this.imageColor,
    required this.inStock,
    required this.discount,
  });
}