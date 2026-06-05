import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/animated_background.dart';

class AnimatedBackgroundsExample extends StatefulWidget {
  const AnimatedBackgroundsExample({super.key});

  @override
  State<AnimatedBackgroundsExample> createState() => _AnimatedBackgroundsExampleState();
}

class _AnimatedBackgroundsExampleState extends State<AnimatedBackgroundsExample> {
  int _selectedBackground = 0;
  final PageController _pageController = PageController();

  final List<BackgroundConfig> _backgrounds = [
    BackgroundConfig(
      'Ocean Breeze',
      'Bubbles floating in deep blue waters',
      Icons.water,
      0,
    ),
    BackgroundConfig(
      'Cosmic Night',
      'Twinkling stars and floating particles',
      Icons.nights_stay,
      1,
    ),
    BackgroundConfig(
      'Sunset Dreams',
      'Warm bubbles and gentle starlight',
      Icons.wb_sunny,
      2,
    ),
    BackgroundConfig(
      'Forest Whispers',
      'Gentle particles in nature\'s embrace',
      Icons.forest,
      3,
    ),
    BackgroundConfig(
      'Custom Galaxy',
      'All effects combined in harmony',
      Icons.auto_awesome,
      4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentBackground(),
    );
  }

  Widget _buildCurrentBackground() {
    switch (_selectedBackground) {
      case 0:
        return OceanAnimatedBackground(
          child: _buildContent(),
        );
      case 1:
        return CosmicAnimatedBackground(
          child: _buildContent(),
        );
      case 2:
        return SunsetAnimatedBackground(
          child: _buildContent(),
        );
      case 3:
        return ForestAnimatedBackground(
          child: _buildContent(),
        );
      case 4:
        return AnimatedBackground(
          primaryColor: const Color(0xFF667eea),
          secondaryColor: const Color(0xFF764ba2),
          showBubbles: true,
          showStars: true,
          showParticles: true,
          child: _buildContent(),
        );
      default:
        return OceanAnimatedBackground(
          child: _buildContent(),
        );
    }
  }

  Widget _buildContent() {
    final currentBg = _backgrounds[_selectedBackground];
    
    return Column(
      children: [
        AppBar(
          title: Text(
            'Animated Backgrounds',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            currentBg.icon,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          currentBg.title,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentBg.description,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        _buildBackgroundSelector(),
                        const SizedBox(height: 30),
                        _buildDemoCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundSelector() {
    return Column(
      children: [
        Text(
          'Choose Background',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: _backgrounds.asMap().entries.map((entry) {
            int index = entry.key;
            BackgroundConfig bg = entry.value;
            bool isSelected = _selectedBackground == index;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedBackground = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      bg.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bg.title.split(' ')[0], // Show only first word
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDemoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Content',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'This card shows how content looks with animated backgrounds',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDemoButton(Icons.favorite, 'Like'),
              _buildDemoButton(Icons.share, 'Share'),
              _buildDemoButton(Icons.bookmark, 'Save'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDemoButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundConfig {
  final String title;
  final String description;
  final IconData icon;
  final int index;

  BackgroundConfig(this.title, this.description, this.icon, this.index);
}