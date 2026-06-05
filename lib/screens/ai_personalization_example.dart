import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIPersonalizationExample extends StatefulWidget {
  const AIPersonalizationExample({super.key});

  @override
  State<AIPersonalizationExample> createState() => _AIPersonalizationExampleState();
}

class _AIPersonalizationExampleState extends State<AIPersonalizationExample> {
  String _selectedTheme = 'Adaptive';
  String _contentPreference = 'Technology';
  double _interactionLevel = 0.7;
  bool _isPersonalizing = false;
  
  final List<String> _recentActivities = [
    'Viewed 5 technology articles',
    'Spent 3 minutes on UI design',
    'Bookmarked Flutter resources',
    'Shared 2 development tips',
  ];

  final Map<String, dynamic> _personalizedContent = {
    'recommendations': [
      {'title': 'Flutter 3.24 Updates', 'score': 95, 'type': 'Article'},
      {'title': 'AI in Mobile Development', 'score': 88, 'type': 'Tutorial'},
      {'title': 'Material You Guidelines', 'score': 82, 'type': 'Guide'},
    ],
    'layoutStyle': 'compact',
    'colorScheme': 'tech-focused',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'AI Personalization',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            onPressed: _triggerPersonalization,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalizationStatus(),
            const SizedBox(height: 24),
            _buildUserPreferences(),
            const SizedBox(height: 24),
            _buildBehaviorAnalysis(),
            const SizedBox(height: 24),
            _buildPersonalizedContent(),
            const SizedBox(height: 24),
            _buildAdaptiveLayout(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizationStatus() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.indigo[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Learning Active',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Personalizing your experience',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Learning Progress',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(_interactionLevel * 100).toInt()}%',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _interactionLevel,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPreferences() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learned Preferences',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildPreferenceItem(
            'Theme Preference',
            _selectedTheme,
            Icons.palette,
            Colors.blue,
            ['Adaptive', 'Light', 'Dark', 'Auto'],
            (value) => setState(() => _selectedTheme = value),
          ),
          const SizedBox(height: 16),
          _buildPreferenceItem(
            'Content Interest',
            _contentPreference,
            Icons.interests,
            Colors.green,
            ['Technology', 'Design', 'Business', 'Science'],
            (value) => setState(() => _contentPreference = value),
          ),
          const SizedBox(height: 16),
          Text(
            'Interaction Level',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _interactionLevel,
            onChanged: (value) => setState(() => _interactionLevel = value),
            divisions: 10,
            label: '${(_interactionLevel * 100).toInt()}%',
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(
    String title,
    String value,
    IconData icon,
    Color color,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              DropdownButton<String>(
                value: value,
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  if (newValue != null) onChanged(newValue);
                },
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option, style: GoogleFonts.poppins()),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBehaviorAnalysis() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.orange[600]),
              const SizedBox(width: 12),
              Text(
                'Behavior Analysis',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...(_recentActivities.map((activity) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.orange[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        activity,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ))),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.orange[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Based on your activity, we recommend more Flutter content',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.orange[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizedContent() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Recommendations',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...(_personalizedContent['recommendations'] as List).map((item) {
            final score = item['score'] as int;
            final color = score >= 90
                ? Colors.green
                : score >= 80
                    ? Colors.orange
                    : Colors.grey;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['type'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$score%',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAdaptiveLayout() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adaptive Interface',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _contentPreference == 'Technology'
                    ? [Colors.blue[100]!, Colors.cyan[50]!]
                    : _contentPreference == 'Design'
                        ? [Colors.purple[100]!, Colors.pink[50]!]
                        : [Colors.green[100]!, Colors.teal[50]!],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _contentPreference == 'Technology'
                        ? Icons.computer
                        : _contentPreference == 'Design'
                            ? Icons.palette
                            : Icons.business,
                    size: 40,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Layout adapted for $_contentPreference',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.auto_fix_high, color: Colors.purple[600], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Interface colors and layout automatically adjust based on your preferences',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _triggerPersonalization() {
    setState(() {
      _isPersonalizing = true;
    });

    // Simulate AI processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isPersonalizing = false;
        _interactionLevel = (_interactionLevel + 0.1).clamp(0.0, 1.0);
        
        // Update recommendations based on preferences
        if (_contentPreference == 'Design') {
          _personalizedContent['recommendations'] = [
            {'title': 'Material Design 3.0', 'score': 96, 'type': 'Guide'},
            {'title': 'UI/UX Best Practices', 'score': 89, 'type': 'Article'},
            {'title': 'Color Theory in Apps', 'score': 84, 'type': 'Tutorial'},
          ];
        }
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🤖 AI is personalizing your experience...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}