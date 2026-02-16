import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activities_provider.dart';
import '../../core/constants.dart';
import 'activity_details_screen.dart';
import 'admin_login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<String> _tabs = ['Programação', 'Minha Agenda', 'Admin'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[_selectedIndex]),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildProgramacaoTab(),
          _buildAgendaTab(),
          const AdminLoginScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(AppIcons.event), label: 'Programação'),
          BottomNavigationBarItem(icon: Icon(AppIcons.favorite), label: 'Minha Agenda'),
          BottomNavigationBarItem(icon: Icon(AppIcons.admin), label: 'Admin'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.secondary,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildProgramacaoTab() {
    return Consumer<ActivitiesProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                children: ['Todos', 'Palestra', 'Workshop'].map((type) {
                  return FilterChip(
                    label: Text(type),
                    selected: provider.filterType == type,
                    onSelected: (selected) {
                      provider.setFilter(type);
                    },
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: provider.activities.length,
                itemBuilder: (context, index) {
                  final activity = provider.activities[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(AppIcons.event, color: AppColors.primary),
                      title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${activity.speakerName} - ${activity.location}'),
                          Text('${activity.startTime.day}/${activity.startTime.month} ${activity.startTime.hour}:${activity.startTime.minute.toString().padLeft(2, '0')} - ${activity.endTime.hour}:${activity.endTime.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      trailing: Chip(label: Text(activity.type, style: const TextStyle(fontSize: 10))),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityDetailsScreen(activity: activity),
                          ),
                        );
                      },
                    ),
                  );
                },
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
            return Card(
              child: ListTile(
                leading: Icon(AppIcons.favorite, color: AppColors.secondary),
                title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${activity.speakerName} - ${activity.location}'),
                    Text('${activity.startTime.day}/${activity.startTime.month} ${activity.startTime.hour}:${activity.startTime.minute.toString().padLeft(2, '0')} - ${activity.endTime.hour}:${activity.endTime.minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
                trailing: Chip(label: Text(activity.type, style: const TextStyle(fontSize: 10))),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityDetailsScreen(activity: activity),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}