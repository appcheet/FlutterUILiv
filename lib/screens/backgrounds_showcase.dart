import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/backgrounds/modern_backgrounds.dart';

class BackgroundsShowcase extends StatefulWidget {
  const BackgroundsShowcase({super.key});

  @override
  State<BackgroundsShowcase> createState() => _BackgroundsShowcaseState();
}

class _BackgroundsShowcaseState extends State<BackgroundsShowcase> {
  BackgroundType _selectedBackground = BackgroundType.mesh;
  double _intensity = 0.4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModernBackground(
        type: _selectedBackground,
        intensity: _intensity,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildControls(),
              Expanded(
                child: _buildBackgroundDemo(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 16),
          Text(
            'Modern Backgrounds',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Background Type',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: BackgroundType.values.map((type) {
              final isSelected = _selectedBackground == type;
              return GestureDetector(
                onTap: () => setState(() => _selectedBackground = type),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.indigo : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getBackgroundName(type),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(
            'Intensity: ${(_intensity * 100).toInt()}%',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _intensity,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            onChanged: (value) => setState(() => _intensity = value),
            activeColor: Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundDemo() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getBackgroundIcon(_selectedBackground),
                size: 60,
                color: Colors.white.withValues(alpha: 0.9),
              ),
              const SizedBox(height: 16),
              Text(
                _getBackgroundName(_selectedBackground),
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _getBackgroundDescription(_selectedBackground),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              _buildFeatureList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = _getBackgroundFeatures(_selectedBackground);
    
    return Column(
      children: features.map((feature) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  feature,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getBackgroundName(BackgroundType type) {
    switch (type) {
      case BackgroundType.mesh:
        return 'Mesh Gradient';
      case BackgroundType.aurora:
        return 'Aurora Borealis';
      case BackgroundType.polar:
        return 'Polar Ice';
      case BackgroundType.gradientBlur:
        return 'Gradient Blur';
      case BackgroundType.galaxy:
        return 'Galaxy Stars';
      case BackgroundType.ocean:
        return 'Ocean Waves';
      case BackgroundType.sunset:
        return 'Sunset Sky';
      case BackgroundType.neon:
        return 'Neon Grid';
    }
  }

  IconData _getBackgroundIcon(BackgroundType type) {
    switch (type) {
      case BackgroundType.mesh:
        return Icons.grid_4x4;
      case BackgroundType.aurora:
        return Icons.waves;
      case BackgroundType.polar:
        return Icons.ac_unit;
      case BackgroundType.gradientBlur:
        return Icons.blur_on;
      case BackgroundType.galaxy:
        return Icons.star;
      case BackgroundType.ocean:
        return Icons.water;
      case BackgroundType.sunset:
        return Icons.wb_sunny;
      case BackgroundType.neon:
        return Icons.flash_on;
    }
  }

  String _getBackgroundDescription(BackgroundType type) {
    switch (type) {
      case BackgroundType.mesh:
        return 'Animated pastel mesh gradient with floating orbs that create a modern, ethereal effect perfect for contemporary designs.';
      case BackgroundType.aurora:
        return 'Mesmerizing aurora borealis effect with flowing waves of green, blue, and purple lights dancing across a dark sky.';
      case BackgroundType.polar:
        return 'Crystalline polar ice effect with shimmering particles and cool blue tones that evoke arctic serenity.';
      case BackgroundType.gradientBlur:
        return 'Sophisticated gradient blend with backdrop blur effects creating depth and modern glass-like aesthetics.';
      case BackgroundType.galaxy:
        return 'Deep space galaxy with twinkling stars and spiral nebula formations in cosmic purple and blue hues.';
      case BackgroundType.ocean:
        return 'Gentle ocean waves with layered blue gradients creating a calming, fluid motion background.';
      case BackgroundType.sunset:
        return 'Warm sunset gradients transitioning from orange to pink and gold, perfect for uplifting interfaces.';
      case BackgroundType.neon:
        return 'Cyberpunk-inspired neon grid with glowing lines that pulse and fade in electric colors.';
    }
  }

  List<String> _getBackgroundFeatures(BackgroundType type) {
    switch (type) {
      case BackgroundType.mesh:
        return [
          'Smooth animated transitions',
          'Customizable color palette',
          'Performance optimized',
          'Perfect for modern apps',
        ];
      case BackgroundType.aurora:
        return [
          'Realistic wave physics',
          'Multiple light layers',
          'Dark theme compatible',
          'Mesmerizing animations',
        ];
      case BackgroundType.polar:
        return [
          'Sparkle particle effects',
          'Cool color temperature',
          'Concentric circle patterns',
          'Minimalist aesthetic',
        ];
      case BackgroundType.gradientBlur:
        return [
          'Backdrop blur effects',
          'Glass morphism support',
          'Multiple gradient stops',
          'High-end visual appeal',
        ];
      case BackgroundType.galaxy:
        return [
          'Spiral galaxy formation',
          'Twinkling star effects',
          'Deep space atmosphere',
          'Cosmic color palette',
        ];
      case BackgroundType.ocean:
        return [
          'Layered wave animation',
          'Ocean blue gradients',
          'Calming motion effects',
          'Natural fluid dynamics',
        ];
      case BackgroundType.sunset:
        return [
          'Warm color transitions',
          'Static gradient beauty',
          'Uplifting atmosphere',
          'Perfect for dashboards',
        ];
      case BackgroundType.neon:
        return [
          'Cyberpunk grid lines',
          'Pulsing neon effects',
          'Futuristic aesthetics',
          'Dark mode optimized',
        ];
    }
  }
}