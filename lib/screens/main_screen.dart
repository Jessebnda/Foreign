import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'feed_screen.dart';
import 'placeholder_screen.dart';
import 'map_screen.dart';
import 'forum_screen.dart';
import 'mentor_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    FeedScreen(),
    GoogleMapScreen(),
    ForumScreen(),
    MentorScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Usamos LayoutBuilder para decidir si mostramos NavigationRail o BottomNavigationBar
    return LayoutBuilder(
      builder: (context, constraints) {
        // Criterio: Si es web o el ancho es mayor a 600px, mostramos NavigationRail
        final bool useRail = kIsWeb || constraints.maxWidth > 600;

        if (!useRail) {
          // Pantallas grandes o web: NavigationRail a la izquierda
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.selected,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Feed'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.map),
                      label: Text('Mapa'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.forum),
                      label: Text('Foro'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school),
                      label: Text('Mentor'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text('Perfil'),
                    ),
                  ],
                ),
                // El contenido principal (Expanded) es la página seleccionada
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          );
        } else {
          // Pantallas pequeñas (móvil): BottomNavigationBar
          return Scaffold(
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Feed',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Mapa',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.forum),
                  label: 'Foro',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Mentor',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
                
              ],
            ),
          );
        }
      },
    );
  }
}
