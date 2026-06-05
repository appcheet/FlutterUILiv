import 'package:flutter/material.dart';
import '../models/ui_example_model.dart';
import '../constants/app_constants.dart';
import '../../screens/sign_in_page.dart';
import '../../screens/cards_examples.dart';
import '../../screens/bottom_navigation_example.dart';
import '../../screens/curved_bottom_navigation_example.dart';
import '../../screens/top_tabs_example.dart';
import '../../screens/twitter_top_tabs_example.dart';
import '../../screens/drawer_example.dart';
import '../../screens/modern_drawer_example.dart';
import '../../screens/glassmorphism_example.dart';
import '../../screens/neumorphism_example.dart';
import '../../screens/gradient_ui_example.dart';
import '../../screens/modern_dark_mode_example.dart';
import '../../screens/minimalist_design_example.dart';
import '../../screens/microinteractions_example.dart';
import '../../screens/ai_personalization_example.dart';
import '../../screens/advanced_gestures_example.dart';
import '../../screens/daily_components_example.dart';
import '../../screens/animated_backgrounds_example.dart';
import '../../screens/animations_example.dart';
import '../../screens/text_widgets_example.dart';
import '../../screens/backgrounds_showcase.dart';
import '../../screens/analytics_dashboard.dart';
import '../../screens/social_media_dashboard.dart';
import '../../screens/ecommerce_dashboard.dart';
import '../../screens/finance_dashboard.dart';
import '../../screens/project_management_dashboard.dart';
import '../../screens/state_management_demo_screen.dart';
import '../../screens/large_list_optimized.dart';
import '../../screens/paginated_list_with_skeleton.dart';
import '../../screens/virtual_scrolling_example.dart';
import '../../screens/lazy_loading_with_refresh.dart';
import '../../screens/comprehensive_charts_example.dart';
import '../../screens/health_crypto_charts.dart';
import '../../screens/smooth_modals_example.dart';
import '../../screens/telegram_dark_mode.dart';

class UIExamplesData {
  static List<UIExampleModel> get examples => [
    UIExampleModel(
      title: 'Sign In Page',
      subtitle: 'Form validation & text inputs',
      icon: Icons.login,
      color: AppColors.primaryBlue,
      page: const SignInPage(),
      isNew: false,
    ),
    UIExampleModel(
      title: 'Beautiful Cards',
      subtitle: 'Card layouts & designs',
      icon: Icons.credit_card,
      color: AppColors.primaryPurple,
      page: const CardsExamples(),
      isNew: false,
    ),
    UIExampleModel(
      title: 'Bottom Navigation',
      subtitle: 'Standard bottom tabs',
      icon: Icons.navigation,
      color: AppColors.primaryGreen,
      page: const BottomNavigationExample(),
      isNew: false,
    ),
    UIExampleModel(
      title: 'Curved Navigation',
      subtitle: 'Modern curved bottom tabs',
      icon: Icons.water_drop,
      color: AppColors.primaryBlue,
      page: const CurvedBottomNavigationExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Top Tab Bar',
      subtitle: 'Standard tab bar',
      icon: Icons.tab,
      color: AppColors.primaryOrange,
      page: const TopTabsExample(),
      isNew: false,
    ),
    UIExampleModel(
      title: 'Twitter-Style Tabs',
      subtitle: 'Twitter-like top tabs',
      icon: Icons.trending_up,
      color: AppColors.primaryLightBlue,
      page: const TwitterTopTabsExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Drawer Navigation',
      subtitle: 'Standard side drawer',
      icon: Icons.menu,
      color: AppColors.primaryRed,
      page: const DrawerExample(),
      isNew: false,
    ),
    UIExampleModel(
      title: 'Modern Drawers',
      subtitle: 'Attractive drawer variants',
      icon: Icons.dashboard_customize,
      color: AppColors.primaryIndigo,
      page: const ModernDrawerExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Glassmorphism',
      subtitle: 'Glass effect UI',
      icon: Icons.opacity,
      color: AppColors.primaryCyan,
      page: const GlassmorphismExample(),
      isNew: false,
    ),
    UIExampleModel(
      title: 'Neumorphism',
      subtitle: 'Soft UI design',
      icon: Icons.circle,
      color: AppColors.primaryGrey,
      page: const NeumorphismExample(),
      isNew: false,
    ),
    UIExampleModel(
      title: 'Gradient UI',
      subtitle: 'Basic gradients',
      icon: Icons.gradient,
      color: AppColors.primaryPink,
      page: const GradientUIExample(),
      isNew: false,
    ),
    UIExampleModel(
      title: 'Dynamic Dark Mode',
      subtitle: 'Adaptive theming with user preferences',
      icon: Icons.dark_mode,
      color: AppColors.primaryDeepPurple,
      page: const ModernDarkModeExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Minimalist Design',
      subtitle: 'Clean navigation & focused content',
      icon: Icons.design_services,
      color: AppColors.primaryIndigo,
      page: const MinimalistDesignExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Microinteractions',
      subtitle: 'Smooth animations & user feedback',
      icon: Icons.animation,
      color: AppColors.primaryOrange,
      page: const MicrointeractionsExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'AI Personalization',
      subtitle: 'Smart UI that adapts to users',
      icon: Icons.psychology,
      color: AppColors.primaryPurple,
      page: const AIPersonalizationExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Advanced Gestures',
      subtitle: 'Multi-touch & natural interactions',
      icon: Icons.gesture,
      color: AppColors.primaryCyan,
      page: const AdvancedGesturesExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Daily Components',
      subtitle: 'Switches, sliders, dropdowns',
      icon: Icons.tune,
      color: AppColors.primaryOrange,
      page: const DailyComponentsExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Animated Backgrounds',
      subtitle: 'Moving bubbles and stars',
      icon: Icons.auto_awesome,
      color: AppColors.primaryPurple,
      page: const AnimatedBackgroundsExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Animations',
      subtitle: 'Flutter animations',
      icon: Icons.animation,
      color: AppColors.primaryRed,
      page: const AnimationsExample(),
      isNew: false,
    ),
    UIExampleModel(
      title: 'Text & Widgets',
      subtitle: 'Text styles & widgets',
      icon: Icons.text_fields,
      color: AppColors.primaryAmber,
      page: const TextWidgetsExample(),
      isNew: false,
    ),
    UIExampleModel(
      title: 'Modern Backgrounds',
      subtitle: 'Mesh, Aurora, Galaxy & more',
      icon: Icons.wallpaper,
      color: AppColors.primaryDeepPurple,
      page: const BackgroundsShowcase(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Analytics Dashboard',
      subtitle: 'Data visualization & KPIs',
      icon: Icons.analytics,
      color: AppColors.primaryBlue,
      page: const AnalyticsDashboard(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Social Media Dashboard',
      subtitle: 'Engagement metrics & insights',
      icon: Icons.thumb_up,
      color: AppColors.primaryPink,
      page: const SocialMediaDashboard(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'E-commerce Dashboard',
      subtitle: 'Sales tracking & orders',
      icon: Icons.shopping_cart,
      color: AppColors.primaryGreen,
      page: const EcommerceDashboard(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Finance Dashboard',
      subtitle: 'Balance, expenses & investments',
      icon: Icons.account_balance,
      color: AppColors.primaryIndigo,
      page: const FinanceDashboard(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Project Dashboard',
      subtitle: 'Task management & team tracking',
      icon: Icons.assignment,
      color: AppColors.primaryTeal,
      page: const ProjectManagementDashboard(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'State Management',
      subtitle: 'Riverpod, BLoC, Provider & GetX examples',
      icon: Icons.architecture,
      color: AppColors.primaryDeepPurple,
      page: const StateManagementDemoScreen(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Large List Optimized',
      subtitle: '1000 items with smooth scrolling',
      icon: Icons.list,
      color: AppColors.primaryBlue,
      page: const LargeListOptimized(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Pagination + Skeleton',
      subtitle: 'Smart loading with skeleton UI',
      icon: Icons.view_list,
      color: AppColors.primaryOrange,
      page: const PaginatedListWithSkeleton(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Virtual Chat Room',
      subtitle: '10k messages with virtual scrolling',
      icon: Icons.chat,
      color: AppColors.primaryGreen,
      page: const VirtualScrollingExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'News Feed',
      subtitle: 'Lazy loading with pull-to-refresh',
      icon: Icons.newspaper,
      color: AppColors.primaryPurple,
      page: const LazyLoadingWithRefresh(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Interactive Charts',
      subtitle: 'Bar, line, pie, donut charts with animations',
      icon: Icons.bar_chart,
      color: AppColors.primaryBlue,
      page: const ComprehensiveChartsExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Health & Crypto Charts',
      subtitle: 'Sleep quality, heart rate & trading charts',
      icon: Icons.favorite,
      color: AppColors.primaryRed,
      page: const HealthCryptoCharts(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Smooth Modals',
      subtitle: 'Bottom sheets, popups with blur effects',
      icon: Icons.layers,
      color: AppColors.primaryPurple,
      page: const SmoothModalsExample(),
      isNew: true,
    ),
    UIExampleModel(
      title: 'Telegram Dark Mode',
      subtitle: 'Ripple animation theme transition',
      icon: Icons.dark_mode_outlined,
      color: AppColors.primaryIndigo,
      page: const TelegramDarkMode(),
      isNew: true,
    ),
  ];
}
