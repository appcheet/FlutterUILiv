import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernDarkModeExample extends StatefulWidget {
  const ModernDarkModeExample({super.key});

  @override
  State<ModernDarkModeExample> createState() => _ModernDarkModeExampleState();
}

class _ModernDarkModeExampleState extends State<ModernDarkModeExample> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _adaptiveTheme = false;

  @override
  Widget build(BuildContext context) {
    final brightness = _themeMode == ThemeMode.system
        ? MediaQuery.of(context).platformBrightness
        : _themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light;
            
    return Theme(
      data: brightness == Brightness.dark 
          ? _buildDarkTheme() 
          : _buildLightTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dynamic Dark Mode',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThemeControls(),
              const SizedBox(height: 32),
              _buildAdaptiveCard(),
              const SizedBox(height: 24),
              _buildContentPreview(),
              const SizedBox(height: 24),
              _buildInteractiveElements(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeControls() {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Controls',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.wb_sunny, color: Colors.orange[400]),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: _themeMode == ThemeMode.light
                        ? 0
                        : _themeMode == ThemeMode.system
                            ? 0.5
                            : 1,
                    divisions: 2,
                    onChanged: (value) {
                      setState(() {
                        if (value == 0) {
                          _themeMode = ThemeMode.light;
                        } else if (value == 0.5) {
                          _themeMode = ThemeMode.system;
                        } else {
                          _themeMode = ThemeMode.dark;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.nightlight_round, color: Colors.indigo[400]),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _themeMode == ThemeMode.light
                  ? 'Light Mode'
                  : _themeMode == ThemeMode.system
                      ? 'System Default'
                      : 'Dark Mode',
              style: GoogleFonts.poppins(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(
                'Adaptive Theme',
                style: GoogleFonts.poppins(),
              ),
              subtitle: Text(
                'Adjust colors based on user preferences',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              value: _adaptiveTheme,
              onChanged: (value) {
                setState(() {
                  _adaptiveTheme = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdaptiveCard() {
    final brightness = _themeMode == ThemeMode.system
        ? MediaQuery.of(context).platformBrightness
        : _themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light;
    final isDark = brightness == Brightness.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _adaptiveTheme
              ? (isDark
                  ? [Colors.deepPurple[900]!, Colors.indigo[800]!]
                  : [Colors.blue[100]!, Colors.purple[50]!])
              : [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
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
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adaptive Design',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'This card adapts to your theme preference',
                      style: GoogleFonts.poppins(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Theme',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      isDark ? 'Dark Mode Active' : 'Light Mode Active',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Content Preview',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: [Colors.blue, Colors.green, Colors.orange][index],
                  child: Text('${index + 1}'),
                ),
                title: Text(
                  'Content Item ${index + 1}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'This content automatically adapts to your theme',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInteractiveElements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interactive Elements',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share),
              label: const Text('Share'),
            ),
          ],
        ),
      ],
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}