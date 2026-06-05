import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyComponentsExample extends StatefulWidget {
  const DailyComponentsExample({super.key});

  @override
  State<DailyComponentsExample> createState() => _DailyComponentsExampleState();
}

class _DailyComponentsExampleState extends State<DailyComponentsExample> {
  bool _switch1Value = true;
  bool _switch2Value = false;
  bool _switch3Value = true;
  
  bool _checkbox1 = true;
  bool _checkbox2 = false;
  bool _checkbox3 = true;
  
  int _radioValue = 1;
  
  double _sliderValue = 50.0;
  double _volumeSlider = 75.0;
  double _brightnessSlider = 30.0;
  
  String? _dropdownValue = 'Option 1';
  String? _countryValue = 'USA';
  
  RangeValues _rangeValues = const RangeValues(20, 80);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Daily Use Components',
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle('Switches & Toggles'),
          const SizedBox(height: 16),
          _buildSwitchesSection(),
          const SizedBox(height: 32),
          
          _buildSectionTitle('Checkboxes & Radio'),
          const SizedBox(height: 16),
          _buildCheckboxRadioSection(),
          const SizedBox(height: 32),
          
          _buildSectionTitle('Sliders & Controls'),
          const SizedBox(height: 16),
          _buildSlidersSection(),
          const SizedBox(height: 32),
          
          _buildSectionTitle('Dropdowns & Selectors'),
          const SizedBox(height: 16),
          _buildDropdownSection(),
          const SizedBox(height: 32),
          
          _buildSectionTitle('Interactive Controls'),
          const SizedBox(height: 16),
          _buildInteractiveSection(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSwitchesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            'Push Notifications',
            'Get notified about important updates',
            Icons.notifications,
            _switch1Value,
            (value) => setState(() => _switch1Value = value),
            Colors.blue,
          ),
          const Divider(height: 32),
          _buildSwitchTile(
            'Dark Mode',
            'Switch to dark theme for better experience',
            Icons.dark_mode,
            _switch2Value,
            (value) => setState(() => _switch2Value = value),
            Colors.purple,
          ),
          const Divider(height: 32),
          _buildSwitchTile(
            'Location Services',
            'Allow app to access your location',
            Icons.location_on,
            _switch3Value,
            (value) => setState(() => _switch3Value = value),
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: color,
        ),
      ],
    );
  }

  Widget _buildCheckboxRadioSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferences',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          
          // Checkboxes
          CheckboxListTile(
            title: Text(
              'Email notifications',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Receive updates via email',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            value: _checkbox1,
            onChanged: (value) => setState(() => _checkbox1 = value!),
            activeColor: Colors.blue,
            secondary: const Icon(Icons.email, color: Colors.blue),
          ),
          CheckboxListTile(
            title: Text(
              'SMS notifications',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Receive updates via SMS',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            value: _checkbox2,
            onChanged: (value) => setState(() => _checkbox2 = value!),
            activeColor: Colors.green,
            secondary: const Icon(Icons.sms, color: Colors.green),
          ),
          CheckboxListTile(
            title: Text(
              'App notifications',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Show in-app notifications',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            value: _checkbox3,
            onChanged: (value) => setState(() => _checkbox3 = value!),
            activeColor: Colors.orange,
            secondary: const Icon(Icons.app_blocking, color: Colors.orange),
          ),
          
          const SizedBox(height: 20),
          Text(
            'Subscription Type',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          // Radio buttons
          RadioListTile<int>(
            title: Text(
              'Free Plan',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Basic features with limited access',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            value: 0,
            groupValue: _radioValue,
            onChanged: (value) => setState(() => _radioValue = value!),
            activeColor: Colors.grey,
            secondary: const Icon(Icons.free_breakfast, color: Colors.grey),
          ),
          RadioListTile<int>(
            title: Text(
              'Premium Plan',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'All features with priority support',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            value: 1,
            groupValue: _radioValue,
            onChanged: (value) => setState(() => _radioValue = value!),
            activeColor: Colors.purple,
            secondary: const Icon(Icons.star, color: Colors.purple),
          ),
          RadioListTile<int>(
            title: Text(
              'Enterprise Plan',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Custom solutions for businesses',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            value: 2,
            groupValue: _radioValue,
            onChanged: (value) => setState(() => _radioValue = value!),
            activeColor: Colors.indigo,
            secondary: const Icon(Icons.business, color: Colors.indigo),
          ),
        ],
      ),
    );
  }

  Widget _buildSlidersSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSliderControl(
            'Temperature',
            Icons.thermostat,
            _sliderValue,
            0,
            100,
            '°C',
            Colors.red,
            (value) => setState(() => _sliderValue = value),
          ),
          const SizedBox(height: 24),
          _buildSliderControl(
            'Volume',
            Icons.volume_up,
            _volumeSlider,
            0,
            100,
            '%',
            Colors.blue,
            (value) => setState(() => _volumeSlider = value),
          ),
          const SizedBox(height: 24),
          _buildSliderControl(
            'Brightness',
            Icons.brightness_6,
            _brightnessSlider,
            0,
            100,
            '%',
            Colors.amber,
            (value) => setState(() => _brightnessSlider = value),
          ),
          const SizedBox(height: 32),
          
          // Range Slider
          Text(
            'Price Range',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.attach_money, color: Colors.green, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${_rangeValues.start.toInt()}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          '\$${_rangeValues.end.toInt()}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: _rangeValues,
                      min: 0,
                      max: 1000,
                      divisions: 100,
                      activeColor: Colors.green,
                      inactiveColor: Colors.green.withValues(alpha: 0.2),
                      onChanged: (values) => setState(() => _rangeValues = values),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderControl(String label, IconData icon, double value, double min, double max, String unit, Color color, ValueChanged<double> onChanged) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${value.toInt()}$unit',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              Slider(
                value: value,
                min: min,
                max: max,
                activeColor: color,
                inactiveColor: color.withValues(alpha: 0.2),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selection Options',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          
          // Standard Dropdown
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.category, color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _dropdownValue,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: ['Option 1', 'Option 2', 'Option 3', 'Option 4']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Country Dropdown with Icons
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.public, color: Colors.green, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Country',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _countryValue,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'USA', child: Row(children: [Text('🇺🇸'), SizedBox(width: 8), Text('United States')])),
                        DropdownMenuItem(value: 'UK', child: Row(children: [Text('🇬🇧'), SizedBox(width: 8), Text('United Kingdom')])),
                        DropdownMenuItem(value: 'Canada', child: Row(children: [Text('🇨🇦'), SizedBox(width: 8), Text('Canada')])),
                        DropdownMenuItem(value: 'Germany', child: Row(children: [Text('🇩🇪'), SizedBox(width: 8), Text('Germany')])),
                        DropdownMenuItem(value: 'France', child: Row(children: [Text('🇫🇷'), SizedBox(width: 8), Text('France')])),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _countryValue = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Like',
                  Icons.thumb_up,
                  Colors.blue,
                  () => _showSnackbar('Liked!'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Share',
                  Icons.share,
                  Colors.green,
                  () => _showSnackbar('Shared!'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Save',
                  Icons.bookmark,
                  Colors.orange,
                  () => _showSnackbar('Saved!'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Download',
                  Icons.download,
                  Colors.purple,
                  () => _showSnackbar('Downloaded!'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Print',
                  Icons.print,
                  Colors.teal,
                  () => _showSnackbar('Printed!'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Delete',
                  Icons.delete,
                  Colors.red,
                  () => _showDeleteDialog(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Toggle Buttons
          Text(
            'View Options',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          ToggleButtons(
            isSelected: const [true, false, false],
            onPressed: (int index) {
              // Handle toggle button press
            },
            borderRadius: BorderRadius.circular(12),
            selectedColor: Colors.white,
            fillColor: Colors.blue,
            color: Colors.grey[600],
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.list),
                    SizedBox(width: 8),
                    Text('List'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.grid_view),
                    SizedBox(width: 8),
                    Text('Grid'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.view_carousel),
                    SizedBox(width: 8),
                    Text('Card'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Confirm Delete',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this item? This action cannot be undone.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSnackbar('Item deleted!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}