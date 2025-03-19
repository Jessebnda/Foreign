import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/main': (_) => const MainScreen(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF121212),
          selectedItemColor: Colors.purpleAccent,
          unselectedItemColor: Colors.grey,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.purpleAccent,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 14),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
          ),
        ),
      ),
    );
  }
}
