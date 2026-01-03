import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'router/app_router.dart';
import 'providers/theme_provider.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Utiliser Consumer pour que MaterialApp se rebuild quand le thème change
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final lightScheme = ColorScheme.fromSeed(
          seedColor: themeProvider.primaryColor,
          brightness: Brightness.light,
        );

        final darkScheme = ColorScheme.fromSeed(
          seedColor: themeProvider.primaryColor,
          brightness: Brightness.dark,
        );

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          title: 'Mes Contacts',

          theme: ThemeData(
            colorScheme: lightScheme,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: lightScheme.primary,
              foregroundColor: Colors.white,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: lightScheme.primary,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: darkScheme,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: darkScheme.primary,
              foregroundColor: Colors.white,
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: darkScheme.primary,
            ),
          ),
          themeMode: themeProvider.themeMode, // <- Le mode sombre fonctionne maintenant
        );
      },
    );
  }
}
