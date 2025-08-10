import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'dart:math' as math;

class TelegramDarkMode extends StatefulWidget {
  const TelegramDarkMode({super.key});

  @override
  State<TelegramDarkMode> createState() => _TelegramDarkModeState();
}

class _TelegramDarkModeState extends State<TelegramDarkMode>
    with TickerProviderStateMixin {
  bool _isDark = false;
  late AnimationController _themeController;
  late AnimationController _rippleController;
  late Animation<double> _themeAnimation;
  late Animation<double> _rippleAnimation;
  
  Offset? _switchPosition;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    
    _themeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _themeAnimation = CurvedAnimation(
      parent: _themeController,
      curve: Curves.easeInOut,
    );

    _rippleAnimation = CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _themeController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _toggleTheme() async {
    if (_isAnimating) return;
    
    setState(() {
      _isAnimating = true;
      _isDark = !_isDark;
    });

    // Start both animations simultaneously
    _rippleController.forward();
    
    if (_isDark) {
      _themeController.forward();
    } else {
      _themeController.reverse();
    }

    // Reset ripple animation after completion
    await Future.delayed(const Duration(milliseconds: 400));
    _rippleController.reset();
    
    setState(() {
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeAnimation,
      builder: (context, child) {
        final lightColor = const Color(0xFFF8F9FA);
        final darkColor = const Color(0xFF1a1a1a);
        final backgroundColor = Color.lerp(lightColor, darkColor, _themeAnimation.value)!;
        
        final lightCardColor = Colors.white;
        final darkCardColor = const Color(0xFF2D2D2D);
        final cardColor = Color.lerp(lightCardColor, darkCardColor, _themeAnimation.value)!;
        
        final lightTextColor = Colors.black87;
        final darkTextColor = Colors.white;
        final textColor = Color.lerp(lightTextColor, darkTextColor, _themeAnimation.value)!;
        
        final lightSubtextColor = Colors.grey[600]!;
        final darkSubtextColor = Colors.grey[400]!;
        final subtextColor = Color.lerp(lightSubtextColor, darkSubtextColor, _themeAnimation.value)!;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Stack(
            children: [
              // Main content
              SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(textColor, subtextColor),
                    Expanded(
                      child: _buildChatList(cardColor, textColor, subtextColor),
                    ),
                  ],
                ),
              ),
              
              // Ripple effect overlay
              if (_switchPosition != null && _isAnimating)
                AnimatedBuilder(
                  animation: _rippleAnimation,
                  builder: (context, child) {
                    if (_rippleAnimation.value == 0) return const SizedBox.shrink();
                    
                    return CustomPaint(
                      painter: RipplePainter(
                        center: _switchPosition!,
                        radius: _rippleAnimation.value * 
                               (MediaQuery.of(context).size.height + 
                                MediaQuery.of(context).size.width),
                        isDark: _isDark,
                        opacity: 0.8 - (_rippleAnimation.value * 0.6), // Fade out as it expands
                      ),
                      size: Size.infinite,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(Color textColor, Color subtextColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: textColor),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Telegram',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  'Dark Mode Animation',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: subtextColor,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTapDown: (details) {
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              _switchPosition = renderBox.globalToLocal(details.globalPosition);
            },
            onTap: _toggleTheme,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isDark ? Icons.dark_mode : Icons.light_mode,
                    color: textColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isDark ? 'Dark' : 'Light',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(Color cardColor, Color textColor, Color subtextColor) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 15,
      itemBuilder: (context, index) {
        return _buildChatItem(index, cardColor, textColor, subtextColor);
      },
    );
  }

  Widget _buildChatItem(int index, Color cardColor, Color textColor, Color subtextColor) {
    final chatData = _getChatData(index);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _isDark 
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: chatData['color'],
              child: Text(
                chatData['initial'],
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (chatData['isOnline'])
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: cardColor, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                chatData['name'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            Text(
              chatData['time'],
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: subtextColor,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                chatData['message'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: subtextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (chatData['unread'] > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${chatData['unread']}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          _showChatDetails(context, chatData, textColor, subtextColor);
        },
      ),
    );
  }

  void _showChatDetails(
    BuildContext context,
    Map<String, dynamic> chatData,
    Color textColor,
    Color subtextColor,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AnimatedBuilder(
        animation: _themeAnimation,
        builder: (context, child) {
          final lightCardColor = Colors.white;
          final darkCardColor = const Color(0xFF2D2D2D);
          final cardColor = Color.lerp(lightCardColor, darkCardColor, _themeAnimation.value)!;
          
          return Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: subtextColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: chatData['color'],
                        child: Text(
                          chatData['initial'],
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        chatData['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        chatData['isOnline'] ? 'Online' : 'Last seen recently',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: subtextColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            Icons.call,
                            'Call',
                            Colors.green,
                            textColor,
                          ),
                          _buildActionButton(
                            Icons.videocam,
                            'Video',
                            Colors.blue,
                            textColor,
                          ),
                          _buildActionButton(
                            Icons.more_horiz,
                            'More',
                            Colors.grey,
                            textColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
    Color textColor,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getChatData(int index) {
    final names = [
      'Alice Johnson', 'Bob Smith', 'Charlie Brown', 'Diana Prince',
      'Edward Norton', 'Fiona Apple', 'George Lucas', 'Hannah Montana',
      'Ian Fleming', 'Julia Roberts', 'Kevin Hart', 'Lisa Simpson',
      'Michael Scott', 'Nancy Drew', 'Oliver Queen'
    ];

    final messages = [
      'Hey! How are you doing?',
      'Just finished the project 🎉',
      'Want to grab lunch tomorrow?',
      'Thanks for your help yesterday!',
      'Did you see the latest episode?',
      'Working from home today',
      'Happy birthday! 🎂',
      'The weather is amazing today ☀️',
      'Can you review this document?',
      'Great meeting today, thanks!',
      'Don\'t forget about the deadline',
      'Just booked our vacation! ✈️',
      'The concert was incredible!',
      'Need your opinion on something',
      'See you at the conference!'
    ];

    final colors = [
      Colors.blue, Colors.green, Colors.orange, Colors.purple,
      Colors.red, Colors.teal, Colors.indigo, Colors.pink,
      Colors.amber, Colors.cyan, Colors.lime, Colors.brown,
      Colors.deepOrange, Colors.deepPurple, Colors.blueGrey
    ];

    final times = [
      '10:30', '09:45', '08:20', '12:15', '14:30',
      '16:45', '11:20', '13:50', '15:10', '17:25',
      '07:40', '18:15', '06:30', '19:45', '20:10'
    ];

    return {
      'name': names[index],
      'message': messages[index],
      'time': times[index],
      'color': colors[index],
      'initial': names[index][0],
      'unread': index < 5 ? math.Random().nextInt(10) : 0,
      'isOnline': index < 8,
    };
  }
}

class RipplePainter extends CustomPainter {
  final Offset center;
  final double radius;
  final bool isDark;
  final double opacity;

  RipplePainter({
    required this.center,
    required this.radius,
    required this.isDark,
    this.opacity = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseColor = isDark ? const Color(0xFF1a1a1a) : const Color(0xFFF8F9FA);
    final paint = Paint()
      ..color = baseColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}