import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n_extension.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell shell;

  const HomeScreen({required this.shell, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) {
          shell.goBranch(index, initialLocation: true);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_rounded),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_drink_rounded),
            label: l10n.navFeedings,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bedtime_rounded),
            label: l10n.navSleep,
          ),
          NavigationDestination(
            icon: const Icon(Icons.monitor_weight_rounded),
            label: l10n.navWeight,
          ),
        ],
      ),
    );
  }
}
