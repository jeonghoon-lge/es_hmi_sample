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
      expect(find.text('Flutter Chart Sample'), findsOneWidget);

      // Check for chart area and control panel
      expect(find.byType(Consumer<ChartProvider>), findsWidgets);

      // Verify the main structure is present
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Chart type can be toggled', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Find chart type buttons
      expect(find.text('막대 그래프'), findsOneWidget);
      expect(find.text('원형 그래프'), findsOneWidget);

      // Tap pie chart button
      await tester.tap(find.text('원형 그래프'));
      await tester.pump();

      // Verify the buttons are still present
      expect(find.text('막대 그래프'), findsOneWidget);
      expect(find.text('원형 그래프'), findsOneWidget);
    });

    testWidgets('Control panel sections are displayed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Check for main control sections
      expect(find.text('컨트롤 패널'), findsOneWidget);
      expect(find.text('차트 타입'), findsOneWidget);
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
