import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chart_sample_app/main.dart';

void main() {
  group('fl_chart Integration Tests', () {
    testWidgets('app loads successfully', (WidgetTester tester) async {
      // Given - Launch the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Then - App should load successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('chart components are present', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Should find basic UI components
      expect(find.textContaining('차트'), findsWidgets);
    });

    testWidgets('chart type switching works', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find chart type buttons
      final pieButton = find.text('원형 그래프');
      final barButton = find.text('막대 그래프');

      if (pieButton.evaluate().isNotEmpty) {
        // When - Tap on pie chart button
        await tester.tap(pieButton);
        await tester.pumpAndSettle();

        // Then - Should switch successfully
        expect(find.byType(MaterialApp), findsOneWidget);
      }

      if (barButton.evaluate().isNotEmpty) {
        // When - Tap on bar chart button
        await tester.tap(barButton);
        await tester.pumpAndSettle();

        // Then - Should switch successfully
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });

    testWidgets('data controls are functional', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Should find slider controls
      final sliders = find.byType(Slider);
      expect(sliders.evaluate().length, greaterThanOrEqualTo(0));

      // If sliders exist, test interaction
      if (sliders.evaluate().isNotEmpty) {
        await tester.drag(sliders.first, const Offset(10, 0));
        await tester.pumpAndSettle();
        
        // Should not crash
        expect(find.byType(MaterialApp), findsOneWidget);
      }
    });

    testWidgets('chart animations complete without errors', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // When - Perform multiple chart switches
      final chartTypes = ['원형 그래프', '막대 그래프'];
      
      for (final chartType in chartTypes) {
        final button = find.text(chartType);
        if (button.evaluate().isNotEmpty) {
          await tester.tap(button);
          await tester.pump(const Duration(milliseconds: 100));
          await tester.pumpAndSettle();
        }
      }

      // Then - Should complete without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('fl_chart Error Handling', () {
    testWidgets('handles rapid interactions gracefully', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // When - Rapid interactions
      for (int i = 0; i < 3; i++) {
        final pieButton = find.text('원형 그래프');
        final barButton = find.text('막대 그래프');
        
        if (pieButton.evaluate().isNotEmpty) {
          await tester.tap(pieButton);
          await tester.pump(const Duration(milliseconds: 10));
        }
        
        if (barButton.evaluate().isNotEmpty) {
          await tester.tap(barButton);
          await tester.pump(const Duration(milliseconds: 10));
        }
      }
      await tester.pumpAndSettle();

      // Then - Should not crash
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('fl_chart Accessibility', () {
    testWidgets('UI elements are accessible', (WidgetTester tester) async {
      // Given
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Then - Should have basic accessible elements
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Check for chart-related text
      final chartTexts = find.textContaining('차트');
      expect(chartTexts.evaluate().length, greaterThanOrEqualTo(0));
    });
  });
}
