import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

/// App Router configuration using GoRouter
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  /// Create GoRouter instance
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutes.root,
      debugLogDiagnostics: true,
      routes: [
        // Root route - Will redirect based on auth state
        GoRoute(
          path: AppRoutes.root,
          builder: (context, state) => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),

        // Auth routes
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Login Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Register Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Forgot Password Screen')),
          ),
        ),

        // Onboarding routes
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Onboarding Screen')),
          ),
          routes: [
            GoRoute(
              path: 'level',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Level Selection Screen')),
              ),
            ),
            GoRoute(
              path: 'persona',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Persona Setup Screen')),
              ),
            ),
          ],
        ),

        // Home route
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Home Screen')),
          ),
        ),

        // Conversation routes
        GoRoute(
          path: AppRoutes.conversation,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Conversation Screen')),
          ),
          routes: [
            GoRoute(
              path: 'summary',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Conversation Summary Screen')),
              ),
            ),
          ],
        ),

        // Learning routes
        GoRoute(
          path: AppRoutes.vocabulary,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Vocabulary List Screen')),
          ),
        ),
        GoRoute(
          path: '/vocabulary/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return Scaffold(
              body: Center(child: Text('Vocabulary Detail: $id')),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.scenarios,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Scenarios Screen')),
          ),
        ),
        GoRoute(
          path: '/challenge/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return Scaffold(
              body: Center(child: Text('Challenge: $id')),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.review,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Review Screen')),
          ),
        ),

        // Gamification routes
        GoRoute(
          path: AppRoutes.badges,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Badges Collection Screen')),
          ),
        ),
        GoRoute(
          path: '/badges/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return Scaffold(
              body: Center(child: Text('Badge Detail: $id')),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.leaderboard,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Leaderboard Screen')),
          ),
        ),

        // Progress routes
        GoRoute(
          path: AppRoutes.progress,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Progress Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.statistics,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Statistics Screen')),
          ),
        ),
        GoRoute(
          path: AppRoutes.history,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('History Screen')),
          ),
        ),

        // Social routes
        GoRoute(
          path: AppRoutes.social,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Social Screen')),
          ),
          routes: [
            GoRoute(
              path: 'invite',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Invite Friends Screen')),
              ),
            ),
            GoRoute(
              path: 'groups',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Groups Screen')),
              ),
            ),
            GoRoute(
              path: 'groups/:id',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? '';
                return Scaffold(
                  body: Center(child: Text('Group Detail: $id')),
                );
              },
            ),
          ],
        ),

        // Profile & Settings routes
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Profile Screen')),
          ),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Edit Profile Screen')),
              ),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Settings Screen')),
          ),
        ),

        // Subscription routes
        GoRoute(
          path: AppRoutes.subscription,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Subscription Screen')),
          ),
          routes: [
            GoRoute(
              path: 'plans',
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Plans Comparison Screen')),
              ),
            ),
          ],
        ),
      ],

      // Error handling
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.uri.path}'),
        ),
      ),
    );
  }
}
