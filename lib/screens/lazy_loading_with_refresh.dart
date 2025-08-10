import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class LazyLoadingWithRefresh extends StatefulWidget {
  const LazyLoadingWithRefresh({super.key});

  @override
  State<LazyLoadingWithRefresh> createState() => _LazyLoadingWithRefreshState();
}

class _LazyLoadingWithRefreshState extends State<LazyLoadingWithRefresh> {
  final List<NewsArticle> _articles = [];
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _articlesPerPage = 15;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All', 'Technology', 'Business', 'Sports', 'Entertainment', 'Health', 'Science'
  ];

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
        _scrollController.position.maxScrollExtent - 300) {
      if (!_isLoading && _hasMoreData && !_isRefreshing) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
    });

    await _simulateNetworkCall();
    
    final newArticles = _generateArticles(1, _articlesPerPage);
    
    setState(() {
      _articles.clear();
      _articles.addAll(newArticles);
      _hasMoreData = newArticles.length == _articlesPerPage;
      _isLoading = false;
    });
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData || _isRefreshing) return;

    setState(() {
      _isLoading = true;
    });

    await _simulateNetworkCall();
    
    final newArticles = _generateArticles(_currentPage + 1, _articlesPerPage);
    
    setState(() {
      _articles.addAll(newArticles);
      _currentPage++;
      _hasMoreData = newArticles.length == _articlesPerPage && _articles.length < 300;
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    if (_isLoading) return;

    setState(() {
      _isRefreshing = true;
    });

    await _simulateNetworkCall();
    
    final newArticles = _generateArticles(1, _articlesPerPage, refresh: true);
    
    setState(() {
      _articles.clear();
      _articles.addAll(newArticles);
      _currentPage = 1;
      _hasMoreData = true;
      _isRefreshing = false;
    });

    _showSnackBar('Articles refreshed successfully!', Colors.green);
  }

  Future<void> _simulateNetworkCall() async {
    await Future.delayed(Duration(milliseconds: 600 + math.Random().nextInt(1000)));
  }

  List<NewsArticle> _generateArticles(int page, int count, {bool refresh = false}) {
    final random = math.Random();
    final authors = ['John Smith', 'Sarah Johnson', 'Mike Chen', 'Emily Davis', 'Alex Wilson'];
    final sources = ['TechNews', 'Business Today', 'Sports Weekly', 'Entertainment Hub', 'Health & Science'];
    
    final headlines = [
      'Revolutionary AI breakthrough changes everything',
      'Market sees unprecedented growth this quarter',
      'Championship finals draw record breaking audience',
      'New medical discovery offers hope for millions',
      'Space mission reveals stunning cosmic secrets',
      'Climate change solutions show promising results',
      'Tech giant announces game-changing innovation',
      'Economic forecast predicts stable recovery',
      'Olympic preparations intensify as games approach',
      'Scientists develop cure for rare disease',
      'Renewable energy hits new efficiency milestone',
      'Social media platform introduces privacy features',
      'Banking sector embraces digital transformation',
      'Professional league expands to new territories',
      'Breakthrough in quantum computing achieved',
      'Global summit addresses environmental concerns',
      'Startup revolutionizes food delivery industry',
      'Healthcare workers receive recognition awards',
      'Archaeological discovery rewrites history books',
      'Wildlife conservation efforts show positive results',
    ];

    List<NewsArticle> articles = [];
    final startId = refresh ? 1000 + random.nextInt(9000) : ((page - 1) * count) + 1;
    
    for (int i = 0; i < count; i++) {
      final articleId = startId + i;
      final category = _selectedCategory == 'All' 
          ? _categories[1 + random.nextInt(_categories.length - 1)]
          : _selectedCategory;
      
      articles.add(NewsArticle(
        id: articleId,
        headline: headlines[random.nextInt(headlines.length)],
        summary: 'This is a detailed summary of the article that provides key insights and important information about the topic being discussed.',
        author: authors[random.nextInt(authors.length)],
        source: sources[random.nextInt(sources.length)],
        category: category,
        publishedAt: DateTime.now().subtract(Duration(
          hours: random.nextInt(72),
          minutes: random.nextInt(60),
        )),
        readTime: random.nextInt(8) + 2,
        likes: random.nextInt(5000),
        comments: random.nextInt(500),
        imageColor: _getCategoryColor(category),
        isBookmarked: random.nextBool(),
        isPremium: random.nextBool(),
      ));
    }
    
    return articles;
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Technology':
        return Colors.blue;
      case 'Business':
        return Colors.green;
      case 'Sports':
        return Colors.orange;
      case 'Entertainment':
        return Colors.purple;
      case 'Health':
        return Colors.red;
      case 'Science':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                'News Feed',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              floating: true,
              snap: true,
              actions: [
                IconButton(
                  onPressed: _refreshData,
                  icon: _isRefreshing 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: _buildCategoryFilter(),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: _articles.isEmpty && _isLoading
              ? _buildLoadingState()
              : _buildArticlesList(),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                category,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  _loadInitialData();
                }
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.blue,
              side: BorderSide(
                color: isSelected ? Colors.blue : Colors.grey[300]!,
              ),
              showCheckmark: false,
            ),
          );
        },
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
          Text('Loading articles...'),
        ],
      ),
    );
  }

  Widget _buildArticlesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _articles.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _articles.length) {
          return _buildLoadingIndicator();
        }
        
        return _buildArticleCard(_articles[index]);
      },
    );
  }

  Widget _buildArticleCard(NewsArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          onTap: () => _showArticleDetails(article),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article image placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: article.imageColor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _getCategoryIcon(article.category),
                        size: 60,
                        color: article.imageColor.withValues(alpha: 0.5),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Row(
                        children: [
                          if (article.isPremium)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'PREMIUM',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              article.isBookmarked 
                                  ? Icons.bookmark 
                                  : Icons.bookmark_border,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category and read time
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: article.imageColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            article.category,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: article.imageColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${article.readTime} min read',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Headline
                    Text(
                      article.headline,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Summary
                    Text(
                      article.summary,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Author and metadata
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: article.imageColor.withValues(alpha: 0.2),
                          child: Text(
                            article.author[0].toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: article.imageColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.author,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${article.source} • ${_formatTime(article.publishedAt)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.favorite_border, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              _formatCount(article.likes),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.comment_outlined, size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              _formatCount(article.comments),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Technology':
        return Icons.computer;
      case 'Business':
        return Icons.business;
      case 'Sports':
        return Icons.sports_soccer;
      case 'Entertainment':
        return Icons.movie;
      case 'Health':
        return Icons.health_and_safety;
      case 'Science':
        return Icons.science;
      default:
        return Icons.article;
    }
  }

  String _formatTime(DateTime publishedAt) {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _formatCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}m';
    }
  }

  void _showArticleDetails(NewsArticle article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          article.headline,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Author: ${article.author}'),
              Text('Source: ${article.source}'),
              Text('Category: ${article.category}'),
              Text('Published: ${_formatTime(article.publishedAt)}'),
              Text('Read time: ${article.readTime} minutes'),
              Text('Likes: ${_formatCount(article.likes)}'),
              Text('Comments: ${_formatCount(article.comments)}'),
              if (article.isPremium) const Text('Premium Content'),
              if (article.isBookmarked) const Text('Bookmarked'),
              const SizedBox(height: 16),
              Text(
                article.summary,
                style: GoogleFonts.poppins(height: 1.4),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Article opened!', Colors.blue);
            },
            child: const Text('Read Full Article'),
          ),
        ],
      ),
    );
  }
}

class NewsArticle {
  final int id;
  final String headline;
  final String summary;
  final String author;
  final String source;
  final String category;
  final DateTime publishedAt;
  final int readTime;
  final int likes;
  final int comments;
  final Color imageColor;
  final bool isBookmarked;
  final bool isPremium;

  NewsArticle({
    required this.id,
    required this.headline,
    required this.summary,
    required this.author,
    required this.source,
    required this.category,
    required this.publishedAt,
    required this.readTime,
    required this.likes,
    required this.comments,
    required this.imageColor,
    required this.isBookmarked,
    required this.isPremium,
  });
}