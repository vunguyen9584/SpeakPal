import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/social/providers/group_provider.dart';
import 'package:mobile/features/social/screens/groups_screen.dart';

void main() {
  group('GroupsScreen Widget Tests', () {
    testWidgets('displays loading indicator while fetching groups',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            myGroupsProvider.overrideWith(
              (ref) => Future.delayed(
                const Duration(seconds: 1),
                () => <Group>[],
              ),
            ),
          ],
          child: const MaterialApp(
            home: GroupsScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays empty state when no groups exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            myGroupsProvider.overrideWith((ref) => Future.value(<Group>[])),
          ],
          child: const MaterialApp(
            home: GroupsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No Groups Yet'), findsOneWidget);
      expect(find.text('Create a group or join one to start\nlearning with friends!'),
          findsOneWidget);
      expect(find.byIcon(Icons.groups_outlined), findsOneWidget);
    });

    testWidgets('displays list of groups when groups exist',
        (WidgetTester tester) async {
      final mockGroups = [
        Group(
          id: 1,
          name: 'English Learners',
          description: 'Practice English together',
          inviteCode: 'ABC123',
          memberCount: 5,
          createdAt: DateTime.now(),
        ),
        Group(
          id: 2,
          name: 'Advanced Speakers',
          description: null,
          inviteCode: 'XYZ789',
          memberCount: 3,
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            myGroupsProvider.overrideWith((ref) => Future.value(mockGroups)),
          ],
          child: const MaterialApp(
            home: GroupsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('English Learners'), findsOneWidget);
      expect(find.text('Advanced Speakers'), findsOneWidget);
      expect(find.text('Practice English together'), findsOneWidget);
      expect(find.text('5 members'), findsOneWidget);
      expect(find.text('3 members'), findsOneWidget);
    });

    testWidgets('shows create group dialog when create button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            myGroupsProvider.overrideWith((ref) => Future.value(<Group>[])),
          ],
          child: const MaterialApp(
            home: GroupsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap create group button
      await tester.tap(find.text('Create Group').first);
      await tester.pumpAndSettle();

      expect(find.text('Create Study Group'), findsOneWidget);
      expect(find.text('Group Name'), findsOneWidget);
      expect(find.text('Description (Optional)'), findsOneWidget);
    });

    testWidgets('shows join group dialog when join button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            myGroupsProvider.overrideWith((ref) => Future.value(<Group>[])),
          ],
          child: const MaterialApp(
            home: GroupsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap join group button
      await tester.tap(find.text('Join Group').first);
      await tester.pumpAndSettle();

      expect(find.text('Join Study Group'), findsOneWidget);
      expect(find.text('Enter the invite code shared by your friend:'),
          findsOneWidget);
      expect(find.text('Invite Code'), findsOneWidget);
    });

    testWidgets('displays error state when loading fails',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            myGroupsProvider.overrideWith(
              (ref) => Future.error('Network error'),
            ),
          ],
          child: const MaterialApp(
            home: GroupsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Failed to load groups'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('refresh indicator works correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            myGroupsProvider.overrideWith((ref) => Future.value(<Group>[])),
          ],
          child: const MaterialApp(
            home: GroupsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the RefreshIndicator
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('floating action buttons are visible',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            myGroupsProvider.overrideWith((ref) => Future.value(<Group>[])),
          ],
          child: const MaterialApp(
            home: GroupsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsNWidgets(2));
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.login), findsOneWidget);
    });
  });
}
