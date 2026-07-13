import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_router.dart';

class PinterestCloneApp extends StatelessWidget {
  const PinterestCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Pinterest Clone',
      routerConfig: appRouter,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE60023),
        ),
      ),
    );
  }
}