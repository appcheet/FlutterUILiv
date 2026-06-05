import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerExample extends StatefulWidget {
  const DrawerExample({super.key});

  @override
  State<DrawerExample> createState() => _DrawerExampleState();
}

class _DrawerExampleState extends State<DrawerExample> {
  String _selectedPage = 'Home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedPage,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      body: _buildBody(),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blue, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/images/image1.png'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'John Doe',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'john.doe@example.com',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home',
              isSelected: _selectedPage == 'Home',
              onTap: () => _selectPage('Home'),
            ),
            _buildDrawerItem(
              icon: Icons.person,
              title: 'Profile',
              isSelected: _selectedPage == 'Profile',
              onTap: () => _selectPage('Profile'),
            ),
            _buildDrawerItem(
              icon: Icons.shopping_cart,
              title: 'Orders',
              isSelected: _selectedPage == 'Orders',
              onTap: () => _selectPage('Orders'),
            ),
            _buildDrawerItem(
              icon: Icons.favorite,
              title: 'Wishlist',
              isSelected: _selectedPage == 'Wishlist',
              onTap: () => _selectPage('Wishlist'),
            ),
            _buildDrawerItem(
              icon: Icons.payment,
              title: 'Payments',
              isSelected: _selectedPage == 'Payments',
              onTap: () => _selectPage('Payments'),
            ),
            const Divider(color: Colors.white30, height: 32),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              isSelected: _selectedPage == 'Settings',
              onTap: () => _selectPage('Settings'),
            ),
            _buildDrawerItem(
              icon: Icons.help,
              title: 'Help & Support',
              isSelected: _selectedPage == 'Help & Support',
              onTap: () => _selectPage('Help & Support'),
            ),
            _buildDrawerItem(
              icon: Icons.info,
              title: 'About',
              isSelected: _selectedPage == 'About',
              onTap: () => _selectPage('About'),
            ),
            const Divider(color: Colors.white30, height: 32),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout clicked')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _selectPage(String page) {
    setState(() {
      _selectedPage = page;
    });
    Navigator.pop(context);
  }

  Widget _buildBody() {
    switch (_selectedPage) {
      case 'Profile':
        return _buildProfilePage();
      case 'Orders':
        return _buildOrdersPage();
      case 'Wishlist':
        return _buildWishlistPage();
      case 'Payments':
        return _buildPaymentsPage();
      case 'Settings':
        return _buildSettingsPage();
      case 'Help & Support':
        return _buildHelpPage();
      case 'About':
        return _buildAboutPage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.home,
                  size: 80,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome to Home!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This is the home page accessed through the drawer navigation.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Quick Stats
          Row(
            children: [
              Expanded(child: _buildStatCard('Orders', '15', Icons.shopping_bag, Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Wishlist', '8', Icons.favorite, Colors.red)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard('Reviews', '23', Icons.star, Colors.amber)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Points', '1,250', Icons.star, Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/image1.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  'John Doe',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Flutter Developer',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'john.doe@example.com',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Profile Options
          ...['Edit Profile', 'Change Password', 'Notification Settings', 'Privacy Policy'].map(
            (option) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: const Icon(Icons.arrow_forward_ios, size: 16),
                title: Text(
                  option,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersPage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.shopping_bag,
                  size: 80,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 20),
                Text(
                  'Your Orders',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Track and manage your orders here.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Order List
          ...List.generate(3, (index) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shopping_bag, color: Colors.indigo),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${1000 + index}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Placed on ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: ₹${(index + 1) * 599}',
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Delivered',
                    style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildWishlistPage() {
    return _buildGenericPage(
      'Wishlist',
      'Your favorite items',
      Icons.favorite,
      'Save items you love for later.',
    );
  }

  Widget _buildPaymentsPage() {
    return _buildGenericPage(
      'Payments',
      'Payment methods',
      Icons.payment,
      'Manage your payment methods and transaction history.',
    );
  }

  Widget _buildSettingsPage() {
    return _buildGenericPage(
      'Settings',
      'App settings',
      Icons.settings,
      'Customize your app experience and preferences.',
    );
  }

  Widget _buildHelpPage() {
    return _buildGenericPage(
      'Help & Support',
      'We\'re here to help',
      Icons.help,
      'Get assistance and find answers to your questions.',
    );
  }

  Widget _buildAboutPage() {
    return _buildGenericPage(
      'About',
      'App information',
      Icons.info,
      'Learn more about our app and company.',
    );
  }

  Widget _buildGenericPage(String title, String subtitle, IconData icon, String description) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 80,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}