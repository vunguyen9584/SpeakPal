import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/shared/widgets/app_button.dart';

void main() {
  group('AppButton Widget Tests', () {
    testWidgets('renders primary variant by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(text: 'Primary'),
          ),
        ),
      );

      expect(find.text('Primary'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('renders secondary variant', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(text: 'Secondary', variant: ButtonVariant.secondary),
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('renders danger variant', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(text: 'Danger', variant: ButtonVariant.danger),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      // In danger variant, it uses ElevatedButton with specific background
      expect(button.style?.backgroundColor?.resolve({}), isNotNull);
    });

    testWidgets('renders text variant', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(text: 'Text', variant: ButtonVariant.text),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('shows loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(text: 'Loading', isLoading: true),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('renders with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(text: 'Icon', icon: Icons.add),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Tap',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap'));
      expect(pressed, true);
    });

    testWidgets('does not call onPressed when loading', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Tap',
              isLoading: true,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // We can't tap the text because it's replaced by indicator
      await tester.tap(find.byType(AppButton));
      expect(pressed, false);
    });

    testWidgets('respects full width setting', (WidgetTester tester) async {
       await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(text: 'Full', isFullWidth: true),
          ),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(elevatedButton.style?.minimumSize?.resolve({})?.width, double.infinity);
    });
  });
}
