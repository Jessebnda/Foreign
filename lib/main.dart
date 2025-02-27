import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Definimos el tema global de la aplicación
      theme: ThemeData(
        // Un tema oscuro (brightness: Brightness.dark) o define scaffoldBackgroundColor manual
        brightness: Brightness.dark,
        // O bien, si prefieres sin brightness:
        // scaffoldBackgroundColor: const Color(0xFF121212),
        
        primarySwatch: Colors.purple,
        
        // Personaliza la AppBar
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        
        // Personaliza el BottomNavigationBar
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF121212),
          selectedItemColor: Colors.purpleAccent,
          unselectedItemColor: Colors.grey,
        ),
        
        // Personaliza la TabBar
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
      home: const MainScreen(),
    );
  }
}
