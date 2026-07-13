import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:printest_flutter/features/auth/login_page.dart';
import 'package:printest_flutter/features/auth/register_page.dart';
import 'package:printest_flutter/features/create_image/create_image_page.dart';
import 'package:printest_flutter/features/detail/detail_page.dart';
import 'package:printest_flutter/features/home/home_page.dart';
import 'package:printest_flutter/features/profile/profile_page.dart';
import 'package:printest_flutter/features/saved/saved_page.dart';
import 'package:printest_flutter/features/shell/main_shell_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    // Login không có bottom navigation
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return const MaterialPage(child: LoginPage());
      },
    ),

    // Register không có bottom navigation
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) {
        return const MaterialPage(child: RegisterPage());
      },
    ),

    // Những trang nằm trong ShellRoute sẽ có bottom navigation
    ShellRoute(
      pageBuilder: (context, state, child) {
        return MaterialPage(child: MainShellPage(child: child));
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) {
            return const MaterialPage(child: HomePage());
          },
        ),

        GoRoute(
          path: '/saved',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SavedPage());
          },
        ),

        GoRoute(
          path: '/create-image',
          pageBuilder: (context, state) {
            return const MaterialPage(child: CreateImagePage());
          },
        ),

        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ProfilePage());
          },
        ),

        // Trang detail
        GoRoute(
          path: '/images/:id',
          pageBuilder: (context, state) {
            final int imageId = int.parse(state.pathParameters['id']!);

            return MaterialPage(child: DetailPage(imageId: imageId));
          },
        ),
      ],
    ),
  ],
);
