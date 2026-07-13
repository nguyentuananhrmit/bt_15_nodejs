import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:printest_flutter/features/auth/provider/auth_provider.dart';
import 'package:printest_flutter/features/detail/provider/detail_provider.dart';
import 'package:printest_flutter/features/home/providers/images_provider.dart';
import 'package:printest_flutter/features/saved/provider/saved_provider.dart';
import 'package:printest_flutter/features/saved/provider/wishlist_provider.dart';

import 'app/app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ImagesProvider()),
        ChangeNotifierProvider(create: (_) => SavedProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => DetailProvider()),
      ],
      child: const PinterestCloneApp(),
    ),
  );
}
