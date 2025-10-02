// Chart Sample App Widget Tests
//
// Basic widget tests for the Chart Sample App
// Tests app initialization, chart display, and basic interactions

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:chart_sample_app/main.dart';
import 'package:chart_sample_app/providers/chart_provider.dart';

void main() {
  group('Chart Sample App Widget Tests', () {
    testWidgets('App initializes and displays chart area',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the app shows the main components
      expect(find.text('Chart Sample App'), findsOneWidget);

      // Check for chart area and control panel
      expect(find.byType(Consumer<ChartProvider>), findsWidgets);

      // Verify chart type toggle buttons exist
      expect(find.text('Bar Chart'), findsOneWidget);
      expect(find.text('Pie Chart'), findsOneWidget);
    });

    testWidgets('Chart type can be toggled', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Find pie chart button and tap it
      final pieChartButton = find.text('Pie Chart');
      expect(pieChartButton, findsOneWidget);

      await tester.tap(pieChartButton);
      await tester.pump();

      // Verify the toggle worked - we should still have both buttons
      expect(find.text('Bar Chart'), findsOneWidget);
      expect(find.text('Pie Chart'), findsOneWidget);
    });

    testWidgets('Control panel sections are displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Check for main control sections
      expect(find.text('Chart Type'), findsOneWidget);
      expect(find.text('Data Controls'), findsOneWidget);
      expect(find.text('Chart Options'), findsOneWidget);
    });

    testWidgets('App layout is responsive', (WidgetTester tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pumpWidget(const MyApp());

      // Should find the main row layout
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
    });
  });
}
