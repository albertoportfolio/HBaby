import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/baby/providers/baby_provider.dart';
import '../features/baby/screens/add_baby_screen.dart';
import '../features/baby/screens/babies_screen.dart';
import '../features/feeding/screens/add_feeding_screen.dart';
import '../features/feeding/screens/feeding_screen.dart';
import '../features/home/screens/dashboard_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/sleep/screens/add_sleep_screen.dart';
import '../features/sleep/screens/sleep_screen.dart';
import '../features/stats/screens/stats_screen.dart';
import '../features/weight/screens/add_weight_screen.dart';
import '../features/weight/screens/weight_screen.dart';
import 'transitions.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final babiesAsync = ref.watch(babiesProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      // If loaded and no babies, and not already heading there → setup
      final babies = babiesAsync.valueOrNull;
      if (babies != null &&
          babies.isEmpty &&
          state.matchedLocation != '/babies/add') {
        return '/babies/add';
      }
      return null;
    },
    routes: [
      // ── Baby management ────────────────────────────────────────────────
      GoRoute(
        path: '/babies',
        pageBuilder: (context, state) =>
            slideUpPage(state, const BabiesScreen()),
        routes: [
          GoRoute(
            path: 'add',
            pageBuilder: (context, state) =>
                slideUpPage(state, const AddBabyScreen()),
          ),
        ],
      ),

      // ── Main shell (bottom nav) ─────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeScreen(shell: shell),
        branches: [
          // 0 · Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // 1 · Feeding
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/feedings',
                builder: (context, state) => const FeedingScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    pageBuilder: (context, state) =>
                        slideUpPage(state, const AddFeedingScreen()),
                  ),
                ],
              ),
            ],
          ),

          // 2 · Sleep
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sleep',
                builder: (context, state) => const SleepScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    pageBuilder: (context, state) =>
                        slideUpPage(state, const AddSleepScreen()),
                  ),
                ],
              ),
            ],
          ),

          // 3 · Weight
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/weight',
                builder: (context, state) => const WeightScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    pageBuilder: (context, state) =>
                        slideUpPage(state, const AddWeightScreen()),
                  ),
                ],
              ),
            ],
          ),

          // 4 · Stats / charts
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/stats',
                builder: (context, state) => const StatsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});