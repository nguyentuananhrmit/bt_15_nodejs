import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:printest_flutter/shared/widgets/app_bottom_nav.dart';

class MainShellPage extends StatelessWidget {
  final Widget child;

  const MainShellPage({super.key, required this.child});

  int getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/saved')) {
      return 1;
    }

    return 0;
  }

  void onTap(BuildContext context, int index) {
    if (index == 0) {
      context.go('/home');
    } else if (index == 1) {
      context.go('/saved');
    } else if (index == 2) {
      context.go('/create-image');
    } else if (index == 3) {
      context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentIndex: getCurrentIndex(context),
        onTap: (index) => onTap(context, index),
      ),
    );
  }
}
