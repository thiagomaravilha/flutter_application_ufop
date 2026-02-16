import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activities_provider.dart';
import '../../core/constants.dart';
import '../widgets/activity_card.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<String> _tabs = AppStrings.tabs;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivitiesProvider>(
      builder: (context, provider, child) {
        String title = _tabs[_selectedIndex];
        if (provider.isLoggedIn && provider.userName != null) {
          title = 'Olá, ${provider.userName}';
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            automaticallyImplyLeading: false,
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Sair', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildProgramacaoTab(),
              _buildAgendaTab(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(AppIcons.event), label: 'Programação'),
              BottomNavigationBarItem(icon: Icon(AppIcons.favorite), label: 'Minha Agenda'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.secondary,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }

  Widget _buildProgramacaoTab() {
    return Consumer<ActivitiesProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70), // Espaço para o filtro
              child: ListView.builder(
                itemCount: provider.activities.length,
                itemBuilder: (context, index) {
                  final activity = provider.activities[index];
                  return ActivityCard(activity: activity);
                },
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  showMenu<String>(
                    context: context,
                    position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
                    items: [
                      const PopupMenuItem<String>(
                        value: 'Palestra',
                        child: Text('Palestra'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Workshop',
                        child: Text('Workshop'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Todos',
                        child: Text('Todos'),
                      ),
                    ],
                  ).then((value) {
                    if (value != null) {
                      provider.setFilter(value);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.filter_list,
                        size: 18,
                        color: provider.filterType != 'Todos' ? Colors.amber : Colors.black87,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Filtro: ${provider.filterType}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAgendaTab() {
    return Consumer<ActivitiesProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favoriteActivities;
        if (favorites.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Nenhuma atividade favorita ainda.', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final activity = favorites[index];
            return ActivityCard(
              activity: activity,
              leadingIcon: AppIcons.favorite,
            );
          },
        );
      },
    );
  }
}