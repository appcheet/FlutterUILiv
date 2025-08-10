import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MicrointeractionsExample extends StatefulWidget {
  const MicrointeractionsExample({super.key});

  @override
  State<MicrointeractionsExample> createState() => _MicrointeractionsExampleState();
}

class _MicrointeractionsExampleState extends State<MicrointeractionsExample>
    with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late AnimationController _heartController;
  late AnimationController _loadingController;
  late AnimationController _pullController;
  
  late Animation<double> _buttonScale;
  late Animation<double> _heartScale;
  late Animation<double> _heartRotation;
  
  bool _isLiked = false;
  bool _isLoading = false;
  double _pullDistance = 0;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pullController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
    
    _heartScale = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );
    
    _heartRotation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _heartController.dispose();
    _loadingController.dispose();
    _pullController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Microinteractions',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Button Feedback'),
            const SizedBox(height: 16),
            _buildButtonInteractions(),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Heart Animation'),
            const SizedBox(height: 16),
            _buildHeartAnimation(),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Loading States'),
            const SizedBox(height: 16),
            _buildLoadingStates(),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Pull to Refresh'),
            const SizedBox(height: 16),
            _buildPullToRefresh(),
            const SizedBox(height: 32),
            
            _buildSectionTitle('Gesture Feedback'),
            const SizedBox(height: 16),
            _buildGestureFeedback(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildButtonInteractions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAnimatedButton(
                'Primary',
                Colors.blue,
                Colors.white,
                () => _animateButton(),
              ),
              _buildAnimatedButton(
                'Secondary',
                Colors.grey[200]!,
                Colors.black87,
                () => _animateButton(),
              ),
              _buildAnimatedButton(
                'Danger',
                Colors.red,
                Colors.white,
                () => _animateButton(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Tap buttons to see scale animation',
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton(String text, Color bg, Color textColor, VoidCallback onTap) {
    return AnimatedBuilder(
      animation: _buttonScale,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScale.value,
          child: GestureDetector(
            onTapDown: (_) => _buttonController.forward(),
            onTapUp: (_) {
              _buttonController.reverse();
              onTap();
            },
            onTapCancel: () => _buttonController.reverse(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: bg.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeartAnimation() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggleHeart,
            child: AnimatedBuilder(
              animation: Listenable.merge([_heartScale, _heartRotation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _heartScale.value,
                  child: Transform.rotate(
                    angle: _heartRotation.value,
                    child: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 64,
                      color: _isLiked ? Colors.red : Colors.grey[400],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: GoogleFonts.poppins(
              color: _isLiked ? Colors.red : Colors.grey[600]!,
              fontWeight: _isLiked ? FontWeight.w600 : FontWeight.normal,
            ),
            child: Text(_isLiked ? 'Liked!' : 'Tap to like'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingStates() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _startLoading,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLoading ? Colors.grey[300] : Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: _isLoading ? 0 : 4,
              ),
              child: _isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Loading...',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      _showSuccess ? 'Success!' : 'Start Process',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
          if (_showSuccess) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Process completed successfully',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPullToRefresh() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _pullDistance,
            child: Center(
              child: _pullDistance > 50
                  ? const CircularProgressIndicator()
                  : Icon(
                      Icons.arrow_downward,
                      color: Colors.grey[400],
                      size: _pullDistance * 0.4,
                    ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                if (details.delta.dy > 0) {
                  setState(() {
                    _pullDistance = (_pullDistance + details.delta.dy).clamp(0.0, 80.0);
                  });
                }
              },
              onPanEnd: (details) {
                if (_pullDistance > 50) {
                  _triggerRefresh();
                } else {
                  setState(() {
                    _pullDistance = 0;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                      size: 48,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pull down to refresh',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGestureFeedback() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGestureCard('Tap', Icons.touch_app, Colors.blue),
              _buildGestureCard('Double Tap', Icons.touch_app, Colors.green),
              _buildGestureCard('Long Press', Icons.touch_app, Colors.orange),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Try different gestures on the cards above',
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGestureCard(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _showFeedback('$label detected!'),
      onDoubleTap: () => _showFeedback('Double $label detected!'),
      onLongPress: () => _showFeedback('Long $label detected!'),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _animateButton() {
    // Button animation is handled in the AnimatedBuilder
  }

  void _toggleHeart() {
    setState(() {
      _isLiked = !_isLiked;
    });
    _heartController.forward().then((_) {
      _heartController.reverse();
    });
  }

  void _startLoading() {
    setState(() {
      _isLoading = true;
      _showSuccess = false;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _showSuccess = true;
      });
      
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showSuccess = false;
          });
        }
      });
    });
  }

  void _triggerRefresh() {
    _pullController.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _pullDistance = 0;
        });
        _pullController.reverse();
        _showFeedback('Refreshed!');
      });
    });
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}