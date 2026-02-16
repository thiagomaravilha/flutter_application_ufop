import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activities_provider.dart';
import 'activity_form_screen.dart';
import 'home_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await context.read<ActivitiesProvider>().authService.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Sair', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Consumer<ActivitiesProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.allActivities.length,
            itemBuilder: (context, index) {
              final activity = provider.allActivities[index];
              return Dismissible(
                key: Key(activity.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
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
                },
                onDismissed: (direction) {
                  provider.deleteActivity(activity.id);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  title: Text(activity.title),
                  subtitle: Text(activity.speakerName),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivityFormScreen(activity: activity),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
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
  }
}