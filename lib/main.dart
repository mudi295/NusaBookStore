import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/catalog_screen.dart';

const Color maroon = Color(0xFF800F2F);
const Color deepMaroon = Color(0xFF590D22);
const Color rosePink = Color(0xFFC9184A);
const Color softPink = Color(0xFFFFCCD5);
const Color blush = Color(0xFFFFF0F3);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const NusaBookstoreApp(),
    ),
  );
}

ThemeData buildTheme({required bool dark}) {
  final scheme = ColorScheme.fromSeed(
    seedColor: dark ? const Color(0xFFFF8FAB) : maroon,
    brightness: dark ? Brightness.dark : Brightness.light,
    primary: dark ? const Color(0xFFFF8FAB) : maroon,
    secondary: dark ? const Color(0xFFFFB3C1) : rosePink,
    surface: dark ? const Color(0xFF28151F) : Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? const Color(0xFF180C12) : blush,
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? const Color(0xFF180C12) : blush,
      foregroundColor: dark ? const Color(0xFFFFF0F3) : const Color(0xFF29151E),
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: dark ? const Color(0xFF28151F) : Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF28151F) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}

class NusaBookstoreApp extends StatelessWidget {
  const NusaBookstoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'NusaBookstore',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(dark: false),
      darkTheme: buildTheme(dark: true),
      themeMode: theme.themeMode,
      home: const CatalogScreen(),
    );
  }
}
