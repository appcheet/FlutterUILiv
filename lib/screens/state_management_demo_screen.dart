import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/backgrounds/modern_backgrounds.dart';
import '../core/constants/app_constants.dart';
import 'riverpod_demo_screen.dart';
import 'bloc_demo_screen.dart';
import 'provider_demo_screen.dart';
import 'getx_demo_screen.dart';

class StateManagementDemoScreen extends ConsumerWidget {
  const StateManagementDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ModernBackground(
        type: BackgroundType.mesh,
        intensity: 0.3,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildDescription(context),
                const SizedBox(height: 40),
                Expanded(
                  child: _buildStateManagementOptions(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.primaryPurple],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.architecture,
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
                    'State Management',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Modern Flutter Patterns',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Different Approaches',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Compare and learn from real examples of Riverpod, BLoC, Provider, and GetX implementations with the same data and UI.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateManagementOptions(BuildContext context) {
    final options = [
      StateManagementOption(
        title: 'Riverpod',
        subtitle: 'Modern reactive state management',
        description: 'Compile-safe, testable, and powerful',
        icon: Icons.refresh,
        color: const Color(0xFF4CAF50),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProviderScope(child: RiverpodDemoScreen())),
        ),
        features: ['Code Generation', 'Type Safety', 'DevTools', 'Testing'],
      ),
      StateManagementOption(
        title: 'BLoC',
        subtitle: 'Business Logic Component',
        description: 'Predictable state management pattern',
        icon: Icons.account_tree,
        color: const Color(0xFF2196F3),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BlocDemoScreen()),
        ),
        features: ['Events & States', 'Reactive', 'Testing', 'DevTools'],
      ),
      StateManagementOption(
        title: 'Provider',
        subtitle: 'Simple and intuitive',
        description: 'Easy to learn and implement',
        icon: Icons.layers,
        color: const Color(0xFFFF9800),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProviderDemoScreen()),
        ),
        features: ['ChangeNotifier', 'InheritedWidget', 'Simple', 'Lightweight'],
      ),
      StateManagementOption(
        title: 'GetX',
        subtitle: 'All-in-one solution',
        description: 'State, routes, and dependency injection',
        icon: Icons.flash_on,
        color: const Color(0xFF9C27B0),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GetXDemoScreen()),
        ),
        features: ['Reactive', 'Routes', 'DI', 'Performance'],
      ),
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return _buildStateManagementCard(context, option);
      },
    );
  }

  Widget _buildStateManagementCard(BuildContext context, StateManagementOption option) {
    return GestureDetector(
      onTap: option.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: option.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  option.icon,
                  color: option.color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                option.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                option.subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                option.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: option.features.take(2).map((feature) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: option.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: option.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StateManagementOption {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final List<String> features;

  const StateManagementOption({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.features,
  });
}