import 'package:flutter/material.dart';
import 'package:tugasku_app/signinpage.dart';
import 'package:tugasku_app/themenotifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeNotifier _themeNotifier = ThemeNotifier(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    return ThemeNotifierProvider(
      notifier: _themeNotifier,
      child: Builder(
        builder: (context) {
          final themeNotifier = ThemeNotifierProvider.of(context);
          return MaterialApp(
            title: 'TugasKu',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              primaryColor: Colors.brown,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              colorScheme: ColorScheme.light(
                primary: Colors.brown,
                secondary: Colors.brown.shade200,
              ),
              textTheme: const TextTheme(
                titleLarge: TextStyle(color: Colors.brown),
                bodyMedium: TextStyle(color: Colors.black87),
              ),
              inputDecorationTheme: InputDecorationTheme(
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
              ),
              iconTheme: const IconThemeData(
                color: Colors.brown,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              primaryColor: Colors.brown.shade300,
              scaffoldBackgroundColor: Colors.grey.shade900,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey.shade800,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              colorScheme: ColorScheme.dark(
                primary: Colors.brown.shade300,
                secondary: Colors.brown.shade200,
              ),
              textTheme: const TextTheme(
                titleLarge: TextStyle(color: Colors.white),
                bodyMedium: TextStyle(color: Colors.white70),
              ),
              inputDecorationTheme: InputDecorationTheme(
                fillColor: Colors.grey.shade800,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade300,
                  foregroundColor: Colors.white,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.brown.shade300,
              ),
            ),
            themeMode: themeNotifier!.value,
            home: const SignInPage(),
          );
        },
      ),
    );
  }
}
