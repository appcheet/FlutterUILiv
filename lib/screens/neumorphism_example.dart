import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeumorphismExample extends StatefulWidget {
  const NeumorphismExample({super.key});

  @override
  State<NeumorphismExample> createState() => _NeumorphismExampleState();
}

class _NeumorphismExampleState extends State<NeumorphismExample> {
  bool _isPressed1 = false;
  bool _isPressed2 = false;
  bool _isPressed3 = false;
  double _sliderValue = 50;
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFE0E5EC);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Neumorphism',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A5568),
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF4A5568)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Card
            _buildNeumorphicContainer(
              width: double.infinity,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 50,
                    color: Color(0xFF667EEA),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Neumorphism UI',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Soft UI Design with depth and shadows',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Interactive Buttons
            Text(
              'Interactive Buttons',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A5568),
              ),
            ),
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTapDown: (_) => setState(() => _isPressed1 = true),
                  onTapUp: (_) => setState(() => _isPressed1 = false),
                  onTapCancel: () => setState(() => _isPressed1 = false),
                  child: _buildNeumorphicButton(
                    isPressed: _isPressed1,
                    child: const Icon(Icons.favorite, color: Colors.red, size: 30),
                  ),
                ),
                GestureDetector(
                  onTapDown: (_) => setState(() => _isPressed2 = true),
                  onTapUp: (_) => setState(() => _isPressed2 = false),
                  onTapCancel: () => setState(() => _isPressed2 = false),
                  child: _buildNeumorphicButton(
                    isPressed: _isPressed2,
                    child: const Icon(Icons.share, color: Color(0xFF667EEA), size: 30),
                  ),
                ),
                GestureDetector(
                  onTapDown: (_) => setState(() => _isPressed3 = true),
                  onTapUp: (_) => setState(() => _isPressed3 = false),
                  onTapCancel: () => setState(() => _isPressed3 = false),
                  child: _buildNeumorphicButton(
                    isPressed: _isPressed3,
                    child: const Icon(Icons.bookmark, color: Color(0xFF48BB78), size: 30),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Profile Card
            Text(
              'Profile Card',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A5568),
              ),
            ),
            const SizedBox(height: 20),
            
            _buildNeumorphicContainer(
              width: double.infinity,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  children: [
                    _buildNeumorphicContainer(
                      width: 80,
                      height: 80,
                      borderRadius: 40,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/image1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'John Doe',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4A5568),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'UI/UX Designer',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: const Color(0xFF718096),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildProfileStat('Projects', '24'),
                              const SizedBox(width: 30),
                              _buildProfileStat('Followers', '1.2K'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Controls Section
            Text(
              'Interactive Controls',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A5568),
              ),
            ),
            const SizedBox(height: 20),
            
            // Slider
            _buildNeumorphicContainer(
              width: double.infinity,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Volume',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4A5568),
                          ),
                        ),
                        Text(
                          '${_sliderValue.round()}%',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF667EEA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 6,
                        thumbShape: _NeumorphicSliderThumb(),
                        activeTrackColor: const Color(0xFF667EEA),
                        inactiveTrackColor: const Color(0xFFE0E5EC),
                      ),
                      child: Slider(
                        value: _sliderValue,
                        min: 0,
                        max: 100,
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Switch
            _buildNeumorphicContainer(
              width: double.infinity,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Mode',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4A5568),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _switchValue = !_switchValue;
                        });
                      },
                      child: _buildNeumorphicSwitch(_switchValue),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Stats Grid
            Text(
              'Statistics',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A5568),
              ),
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Downloads', '1.2M', Icons.download, const Color(0xFF48BB78)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatCard('Likes', '24.5K', Icons.favorite, const Color(0xFFED64A6)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Reviews', '4.8★', Icons.star, const Color(0xFFECC94B)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatCard('Views', '892K', Icons.visibility, const Color(0xFF667EEA)),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Music Player
            Text(
              'Music Player',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A5568),
              ),
            ),
            const SizedBox(height: 20),
            
            _buildNeumorphicContainer(
              width: double.infinity,
              height: 220,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildNeumorphicContainer(
                          width: 60,
                          height: 60,
                          borderRadius: 15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/images/image2.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bohemian Rhapsody',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4A5568),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Queen',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    
                    // Progress bar
                    _buildNeumorphicContainer(
                      width: double.infinity,
                      height: 8,
                      borderRadius: 4,
                      isInset: true,
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF667EEA),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMusicButton(Icons.skip_previous),
                        _buildMusicButton(Icons.pause, isLarge: true),
                        _buildMusicButton(Icons.skip_next),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeumorphicContainer({
    required double width,
    required double height,
    double? borderRadius,
    bool isInset = false,
    required Widget child,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        boxShadow: isInset ? [] : [
          const BoxShadow(
            color: Color(0xFFBEC8D1),
            offset: Offset(8, 8),
            blurRadius: 15,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-8, -8),
            blurRadius: 15,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildNeumorphicButton({required bool isPressed, required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(35),
        boxShadow: isPressed ? [
          const BoxShadow(
            color: Color(0xFFBEC8D1),
            offset: Offset(4, 4),
            blurRadius: 8,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 8,
          ),
        ] : [
          const BoxShadow(
            color: Color(0xFFBEC8D1),
            offset: Offset(6, 6),
            blurRadius: 12,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -6),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildNeumorphicSwitch(bool value) {
    return Container(
      width: 60,
      height: 30,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFBEC8D1),
            offset: Offset(3, 3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-3, -3),
            blurRadius: 6,
          ),
        ],
      ),
      child: AnimatedAlign(
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? const Color(0xFF667EEA) : const Color(0xFFE0E5EC),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFBEC8D1),
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-2, -2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return _buildNeumorphicContainer(
      width: double.infinity,
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A5568),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicButton(IconData icon, {bool isLarge = false}) {
    return _buildNeumorphicContainer(
      width: isLarge ? 60 : 50,
      height: isLarge ? 60 : 50,
      borderRadius: isLarge ? 30 : 25,
      child: Icon(
        icon,
        color: const Color(0xFF667EEA),
        size: isLarge ? 30 : 25,
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4A5568),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFF718096),
          ),
        ),
      ],
    );
  }
}

class _NeumorphicSliderThumb extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(24, 24);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint shadowPaint = Paint()
      ..color = const Color(0xFFBEC8D1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final Paint lightShadowPaint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final Paint paint = Paint()
      ..color = const Color(0xFFE0E5EC);

    canvas.drawCircle(center + const Offset(3, 3), 12, shadowPaint);
    canvas.drawCircle(center + const Offset(-3, -3), 12, lightShadowPaint);
    canvas.drawCircle(center, 12, paint);
  }
}