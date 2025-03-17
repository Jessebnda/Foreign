import 'package:flutter/material.dart'; 
import 'package:firebase_core/firebase_core.dart';  // Agregar la importación
import 'screens/main_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';  // Agregar importación para las opciones de Firebase

void main() async {
  // Asegúrate de que Firebase esté inicializado antes de correr la app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Usamos el archivo de configuración generado
  );

  runApp(
    DevicePreview(builder: (context) => const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Definimos el tema global de la aplicación
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
      home: const MainScreen(),
    );
  }
}
