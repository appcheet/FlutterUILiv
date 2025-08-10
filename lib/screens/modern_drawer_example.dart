import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';

class ModernDrawerExample extends StatefulWidget {
  const ModernDrawerExample({super.key});

  @override
  State<ModernDrawerExample> createState() => _ModernDrawerExampleState();
}

class _ModernDrawerExampleState extends State<ModernDrawerExample> with TickerProviderStateMixin {
  int _selectedDrawerVariant = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Modern Drawer Variants',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      drawer: _buildCurrentDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.purple, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
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
                    const Icon(
                      Icons.menu,
                      size: 60,
                      color: Colors.indigo,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Modern Drawer Variants',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap the menu icon to explore different drawer styles',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Drawer Variants',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildVariantChip('Glass', 0),
                        _buildVariantChip('Gradient', 1),
                        _buildVariantChip('Minimal', 2),
                        _buildVariantChip('Dark', 3),
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

  Widget _buildVariantChip(String title, int variant) {
    bool isSelected = _selectedDrawerVariant == variant;
    return FilterChip(
      label: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : Colors.indigo,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedDrawerVariant = variant;
        });
      },
      selectedColor: Colors.indigo,
      backgroundColor: Colors.white,
      checkmarkColor: Colors.white,
    );
  }

  Widget _buildCurrentDrawer() {
    switch (_selectedDrawerVariant) {
      case 0:
        return _buildGlassDrawer();
      case 1:
        return _buildGradientDrawer();
      case 2:
        return _buildMinimalDrawer();
      case 3:
        return _buildDarkDrawer();
      default:
        return _buildGlassDrawer();
    }
  }

  Widget _buildGlassDrawer() {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 0,
        blur: 20,
        alignment: Alignment.bottomCenter,
        border: 0,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.5),
            Colors.white.withValues(alpha: 0.2),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Glass Design',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'user@example.com',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildGlassDrawerItem(Icons.home, 'Home'),
                    _buildGlassDrawerItem(Icons.person, 'Profile'),
                    _buildGlassDrawerItem(Icons.settings, 'Settings'),
                    _buildGlassDrawerItem(Icons.favorite, 'Favorites'),
                    _buildGlassDrawerItem(Icons.help, 'Help'),
                    const SizedBox(height: 20),
                    Container(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 20),
                    _buildGlassDrawerItem(Icons.logout, 'Logout'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDrawerItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildGradientDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purple, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Gradient Style',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Modern & Colorful',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildGradientDrawerItem(Icons.home, 'Home', Colors.orange),
                    _buildGradientDrawerItem(Icons.person, 'Profile', Colors.blue),
                    _buildGradientDrawerItem(Icons.settings, 'Settings', Colors.green),
                    _buildGradientDrawerItem(Icons.favorite, 'Favorites', Colors.red),
                    _buildGradientDrawerItem(Icons.help, 'Help', Colors.cyan),
                    const SizedBox(height: 20),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 20),
                    _buildGradientDrawerItem(Icons.logout, 'Logout', Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientDrawerItem(IconData icon, String title, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildMinimalDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Minimal Design',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              'Clean & Simple',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildMinimalDrawerItem(Icons.home_outlined, 'Home'),
                  _buildMinimalDrawerItem(Icons.person_outline, 'Profile'),
                  _buildMinimalDrawerItem(Icons.settings_outlined, 'Settings'),
                  _buildMinimalDrawerItem(Icons.favorite_outline, 'Favorites'),
                  _buildMinimalDrawerItem(Icons.help_outline, 'Help'),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  _buildMinimalDrawerItem(Icons.logout_outlined, 'Logout'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalDrawerItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700], size: 24),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () => Navigator.pop(context),
        hoverColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildDarkDrawer() {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.purple[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(3),
              child: const CircleAvatar(
                radius: 37,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Dark Theme',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Elegant & Modern',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildDarkDrawerItem(Icons.home, 'Home', Colors.blue),
                  _buildDarkDrawerItem(Icons.person, 'Profile', Colors.green),
                  _buildDarkDrawerItem(Icons.settings, 'Settings', Colors.orange),
                  _buildDarkDrawerItem(Icons.favorite, 'Favorites', Colors.red),
                  _buildDarkDrawerItem(Icons.help, 'Help', Colors.purple),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 20),
                  _buildDarkDrawerItem(Icons.logout, 'Logout', Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkDrawerItem(IconData icon, String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}