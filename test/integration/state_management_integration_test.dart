import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/screens/state_management_demo_screen.dart';
import 'package:test_app/screens/riverpod_demo_screen.dart';

void main() {
  group('State Management Integration Tests', () {
    testWidgets('should navigate to state management demo screen', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: StateManagementDemoScreen(),
          ),
        ),
      );

      // Verify the main screen is displayed
      expect(find.text('State Management'), findsOneWidget);
      expect(find.text('Modern Flutter Patterns'), findsOneWidget);
      expect(find.text('Explore Different Approaches'), findsOneWidget);

      // Verify all state management options are present
      expect(find.text('Riverpod'), findsOneWidget);
      expect(find.text('BLoC'), findsOneWidget);
      expect(find.text('Provider'), findsOneWidget);
      expect(find.text('GetX'), findsOneWidget);
    });

    testWidgets('should navigate to Riverpod demo screen when tapped', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const StateManagementDemoScreen(),
            routes: {
              '/riverpod': (context) => const RiverpodDemoScreen(),
            },
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Find and tap the Riverpod card
      final riverpodCard = find.ancestor(
        of: find.text('Riverpod'),
        matching: find.byType(GestureDetector),
      );
      
      expect(riverpodCard, findsOneWidget);
      await tester.tap(riverpodCard);
      await tester.pumpAndSettle();

      // Verify navigation to Riverpod screen
      expect(find.text('Riverpod Demo'), findsOneWidget);
    });

    testWidgets('should display proper UI elements on Riverpod demo screen', (WidgetTester tester) async {
      // Build the Riverpod demo screen directly
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RiverpodDemoScreen(),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify header elements
      expect(find.text('Riverpod State Management'), findsOneWidget);
      expect(find.text('Modern reactive programming with code generation'), findsOneWidget);

      // Verify search bar
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search users by name, username, or email...'), findsOneWidget);

      // Verify app bar buttons
      expect(find.byIcon(Icons.refresh), findsWidgets);
      expect(find.byIcon(Icons.clear_all), findsOneWidget);
    });

    testWidgets('should show loading state initially', (WidgetTester tester) async {
      // Build the Riverpod demo screen
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RiverpodDemoScreen(),
          ),
        ),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      expect(find.text('Loading users...'), findsOneWidget);
    });

    testWidgets('should handle search input correctly', (WidgetTester tester) async {
      // Build the Riverpod demo screen
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RiverpodDemoScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the search field
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      // Enter search text
      await tester.enterText(searchField, 'John');
      await tester.pumpAndSettle();

      // Verify clear button appears when text is entered
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // Verify search field is cleared
      expect(find.text('John'), findsNothing);
    });

    testWidgets('should display proper background animations', (WidgetTester tester) async {
      // Build the main screen
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: StateManagementDemoScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify modern background is present
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('should maintain proper app theme and styling', (WidgetTester tester) async {
      // Build the main screen
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: StateManagementDemoScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify app bar styling
      final appBar = find.byType(AppBar);
      expect(appBar, findsNothing); // StateManagementDemoScreen doesn't have AppBar

      // Verify container styling with proper decorations
      final containers = find.byType(Container);
      expect(containers, findsAtLeastNWidgets(1));

      // Verify text styling
      final headerText = find.text('State Management');
      expect(headerText, findsOneWidget);
    });
  });
}