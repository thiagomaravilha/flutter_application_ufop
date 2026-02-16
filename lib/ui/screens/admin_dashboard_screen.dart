import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activities_provider.dart';
import '../../core/constants.dart';
import '../widgets/activity_card.dart';
import 'activity_form_screen.dart';
import 'welcome_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
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
          title = 'Olá, ${provider.userName} (Admin)';
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            automaticallyImplyLeading: false,
            actions: [
              TextButton.icon(
                onPressed: () async {
                  await context.read<ActivitiesProvider>().authService.signOut();
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActivityFormScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
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
                children: AppStrings.activityTypes.map((type) {
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
                  return ActivityCard(
                    activity: activity,
                    showAdminActions: true,
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityFormScreen(activity: activity),
                        ),
                      );
                    },
                    onDelete: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar exclusão'),
                          content: Text('Excluir ${activity.title}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        provider.deleteActivity(activity.id);
                      }
                    },
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
            return ActivityCard(
              activity: activity,
              showAdminActions: true,
              leadingIcon: AppIcons.favorite,
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityFormScreen(activity: activity),
                  ),
                );
              },
              onDelete: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmar exclusão'),
                    content: Text('Excluir ${activity.title}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Excluir'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  provider.deleteActivity(activity.id);
                }
              },
            );
          },
        );
      },
    );
  }
}