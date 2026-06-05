import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdvancedGesturesExample extends StatefulWidget {
  const AdvancedGesturesExample({super.key});

  @override
  State<AdvancedGesturesExample> createState() => _AdvancedGesturesExampleState();
}

class _AdvancedGesturesExampleState extends State<AdvancedGesturesExample>
    with TickerProviderStateMixin {
  late AnimationController _swipeController;
  late AnimationController _pinchController;
  late AnimationController _rotateController;
  
  double _scale = 1.0;
  double _rotation = 0.0;
  Offset _offset = Offset.zero;
  
  final bool _isDragging = false;
  final bool _showSwipeActions = false;
  
  final List<Map<String, dynamic>> _items = [
    {'title': 'Swipe me left or right', 'color': Colors.blue, 'id': 1},
    {'title': 'Pinch to zoom this card', 'color': Colors.green, 'id': 2},
    {'title': 'Long press for actions', 'color': Colors.orange, 'id': 3},
    {'title': 'Double tap to favorite', 'color': Colors.purple, 'id': 4},
  ];

  final List<int> _favorites = [];
  final List<int> _dismissed = [];

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pinchController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _swipeController.dispose();
    _pinchController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Advanced Gestures',
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
            _buildGestureGuide(),
            const SizedBox(height: 24),
            _buildPinchToZoomDemo(),
            const SizedBox(height: 24),
            _buildSwipeActionsDemo(),
            const SizedBox(height: 24),
            _buildMultiTouchDemo(),
            const SizedBox(height: 24),
            _buildPullToRefreshDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildGestureGuide() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[400]!, Colors.purple[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '👆 Gesture Guide',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildGestureItem('Swipe', 'Left/Right to dismiss', Icons.swipe),
          _buildGestureItem('Pinch', 'Zoom in and out', Icons.pinch),
          _buildGestureItem('Long Press', 'Hold for context menu', Icons.touch_app),
          _buildGestureItem('Double Tap', 'Quick actions', Icons.touch_app),
          _buildGestureItem('Rotate', 'Two finger rotation', Icons.rotate_right),
        ],
      ),
    );
  }

  Widget _buildGestureItem(String gesture, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gesture,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinchToZoomDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pinch to Zoom',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
          child: GestureDetector(
            onScaleStart: (details) {
              _pinchController.reset();
            },
            onScaleUpdate: (details) {
              setState(() {
                _scale = details.scale.clamp(0.5, 3.0);
              });
            },
            onScaleEnd: (details) {
              if (_scale < 1.0) {
                setState(() {
                  _scale = 1.0;
                });
              }
            },
            child: Center(
              child: Transform.scale(
                scale: _scale,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink[300]!, Colors.orange[300]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(_scale * 100).toInt()}%',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeActionsDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Swipe Actions',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...(_items.where((item) => !_dismissed.contains(item['id'])).map((item) {
          return _buildSwipeableItem(item);
        })),
        if (_dismissed.isNotEmpty) ...[
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _dismissed.clear();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Restore dismissed items'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSwipeableItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(item['id'].toString()),
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.check, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Complete',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        secondaryBackground: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Delete',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Icon(Icons.delete, color: Colors.white),
              ],
            ),
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            _dismissed.add(item['id']);
          });
          
          final action = direction == DismissDirection.startToEnd ? 'completed' : 'deleted';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Item $action'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {
              if (_favorites.contains(item['id'])) {
                _favorites.remove(item['id']);
              } else {
                _favorites.add(item['id']);
              }
            });
          },
          onLongPress: () {
            _showContextMenu(context, item);
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: _favorites.contains(item['id'])
                  ? Border.all(color: Colors.amber, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _favorites.contains(item['id']) ? Icons.favorite : Icons.touch_app,
                    color: item['color'],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item['title'],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.drag_handle, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiTouchDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Multi-Touch Rotate',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
          child: GestureDetector(
            onScaleStart: (details) {
              _rotateController.reset();
            },
            onScaleUpdate: (details) {
              setState(() {
                _rotation = details.rotation;
                _offset = details.focalPoint - const Offset(200, 100);
              });
            },
            onScaleEnd: (details) {
              // Snap back to original position
              setState(() {
                _rotation = 0.0;
                _offset = Offset.zero;
              });
            },
            child: Center(
              child: Transform.translate(
                offset: _offset * 0.5,
                child: Transform.rotate(
                  angle: _rotation,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyan[400]!, Colors.blue[500]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.rotate_right,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Use two fingers to rotate and move',
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPullToRefreshDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pull to Refresh',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🔄 Content refreshed!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: ListView.builder(
              itemCount: 5,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: [
                          Colors.blue,
                          Colors.green,
                          Colors.orange,
                          Colors.purple,
                          Colors.red
                        ][index],
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Pull down to refresh item ${index + 1}',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showContextMenu(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Actions for ${item['title']}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _buildContextMenuItem(Icons.edit, 'Edit', () {}),
              _buildContextMenuItem(Icons.share, 'Share', () {}),
              _buildContextMenuItem(
                Icons.favorite,
                _favorites.contains(item['id']) ? 'Unfavorite' : 'Favorite',
                () {
                  setState(() {
                    if (_favorites.contains(item['id'])) {
                      _favorites.remove(item['id']);
                    } else {
                      _favorites.add(item['id']);
                    }
                  });
                  Navigator.pop(context);
                },
              ),
              _buildContextMenuItem(
                Icons.delete,
                'Delete',
                () {
                  setState(() {
                    _dismissed.add(item['id']);
                  });
                  Navigator.pop(context);
                },
                isDestructive: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContextMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.grey[700],
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}