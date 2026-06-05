import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidgetsExample extends StatefulWidget {
  const TextWidgetsExample({super.key});

  @override
  State<TextWidgetsExample> createState() => _TextWidgetsExampleState();
}

class _TextWidgetsExampleState extends State<TextWidgetsExample> {
  final TextEditingController _textController = TextEditingController();
  bool _isObscured = true;
  String _selectedOption = 'Option 1';
  double _sliderValue = 50.0;
  bool _switchValue = false;
  bool _checkboxValue = false;
  int _radioValue = 1;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Text & Widgets',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
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
                      Icons.text_fields,
                      size: 60,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Text & Widget Showcase',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Various text styles and interactive widgets',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Text Styles
              _buildSectionTitle('Text Styles'),
              _buildSection([
                _buildTextExample('Display Large', GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )),
                _buildTextExample('Headline Medium', GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo,
                )),
                _buildTextExample('Title Large', GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurple,
                )),
                _buildTextExample('Body Large', GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                )),
                _buildTextExample('Body Medium', GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[700],
                )),
                _buildTextExample('Label Small', GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  letterSpacing: 1.2,
                )),
              ]),
              
              const SizedBox(height: 30),
              
              // Styled Text Examples
              _buildSectionTitle('Styled Text'),
              _buildSection([
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.purple, Colors.pink],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Gradient Background Text',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Border Text Container',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Underlined Text with Decoration',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Strike Through Text',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    text: 'Rich Text with ',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: 'different ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      TextSpan(
                        text: 'styles ',
                        style: GoogleFonts.poppins(
                          fontStyle: FontStyle.italic,
                          color: Colors.green,
                        ),
                      ),
                      TextSpan(
                        text: 'combined',
                        style: GoogleFonts.poppins(
                          decoration: TextDecoration.underline,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              
              const SizedBox(height: 30),
              
              // Input Widgets
              _buildSectionTitle('Input Widgets'),
              _buildSection([
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'Standard TextField',
                    hintText: 'Enter some text...',
                    prefixIcon: const Icon(Icons.text_fields),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.amber, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    labelText: 'Password Field',
                    hintText: 'Enter password...',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.amber, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Multiline TextField',
                    hintText: 'Enter multiple lines of text...',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.amber, width: 2),
                    ),
                  ),
                ),
              ]),
              
              const SizedBox(height: 30),
              
              // Selection Widgets
              _buildSectionTitle('Selection Widgets'),
              _buildSection([
                DropdownButtonFormField<String>(
                  value: _selectedOption,
                  decoration: InputDecoration(
                    labelText: 'Dropdown',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: ['Option 1', 'Option 2', 'Option 3', 'Option 4']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                
                // Slider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Slider: ${_sliderValue.round()}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      activeColor: Colors.amber,
                      inactiveColor: Colors.amber.withValues(alpha: 0.3),
                      onChanged: (double value) {
                        setState(() {
                          _sliderValue = value;
                        });
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Switch Widget',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Switch(
                      value: _switchValue,
                      activeColor: Colors.amber,
                      onChanged: (bool value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _checkboxValue,
                      activeColor: Colors.amber,
                      onChanged: (bool? value) {
                        setState(() {
                          _checkboxValue = value ?? false;
                        });
                      },
                    ),
                    Text(
                      'Checkbox Option',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Radio Buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Radio Buttons:',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ...List.generate(3, (index) {
                      return RadioListTile<int>(
                        title: Text('Option ${index + 1}'),
                        value: index + 1,
                        groupValue: _radioValue,
                        activeColor: Colors.amber,
                        onChanged: (int? value) {
                          setState(() {
                            _radioValue = value!;
                          });
                        },
                      );
                    }),
                  ],
                ),
              ]),
              
              const SizedBox(height: 30),
              
              // Button Widgets
              _buildSectionTitle('Button Widgets'),
              _buildSection([
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Elevated Button',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.amber, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Outlined Button',
                          style: GoogleFonts.poppins(
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Text Button',
                          style: GoogleFonts.poppins(
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite),
                        color: Colors.red,
                        iconSize: 30,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FloatingActionButton.extended(
                  onPressed: () {},
                  backgroundColor: Colors.amber,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    'Extended FAB',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]),
              
              const SizedBox(height: 30),
              
              // Progress Indicators
              _buildSectionTitle('Progress Indicators'),
              _buildSection([
                const LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularProgressIndicator(
                      value: 0.7,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                    CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
                ),
              ]),
              
              const SizedBox(height: 30),
              
              // Chips
              _buildSectionTitle('Chip Widgets'),
              _buildSection([
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      label: const Text('Basic Chip'),
                      backgroundColor: Colors.amber.withValues(alpha: 0.2),
                    ),
                    Chip(
                      label: const Text('Avatar Chip'),
                      avatar: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text('A'),
                      ),
                      backgroundColor: Colors.blue.withValues(alpha: 0.2),
                    ),
                    ActionChip(
                      label: const Text('Action Chip'),
                      onPressed: () {},
                      backgroundColor: Colors.green.withValues(alpha: 0.2),
                    ),
                    FilterChip(
                      label: const Text('Filter Chip'),
                      selected: true,
                      onSelected: (bool selected) {},
                      backgroundColor: Colors.purple.withValues(alpha: 0.2),
                      selectedColor: Colors.purple.withValues(alpha: 0.4),
                    ),
                  ],
                ),
              ]),
              
              const SizedBox(height: 30),
              
              // Icons
              _buildSectionTitle('Icon Examples'),
              _buildSection([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.home, size: 40, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text('Home', style: GoogleFonts.poppins(fontSize: 14)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.favorite, size: 40, color: Colors.red),
                        const SizedBox(height: 8),
                        Text('Favorite', style: GoogleFonts.poppins(fontSize: 14)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.settings, size: 40, color: Colors.grey),
                        const SizedBox(height: 8),
                        Text('Settings', style: GoogleFonts.poppins(fontSize: 14)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.star, size: 40, color: Colors.amber),
                        const SizedBox(height: 8),
                        Text('Star', style: GoogleFonts.poppins(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTextExample(String label, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: style),
          const SizedBox(height: 4),
          Text(
            'Style: ${style.fontSize}px, ${style.fontWeight?.toString().split('.').last ?? 'normal'}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}