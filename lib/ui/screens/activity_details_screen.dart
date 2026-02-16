import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activities_provider.dart';
import '../../models/activity_model.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import 'activity_form_screen.dart';

class ActivityDetailsScreen extends StatelessWidget {
  final ActivityModel activity;

  const ActivityDetailsScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(AppIcons.person, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text('Palestrante: ${activity.speakerName}', style: Theme.of(context).textTheme.headlineSmall)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(AppIcons.description, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text('Descrição: ${activity.description}')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(AppIcons.location, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Local: ${activity.location}'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(AppIcons.time, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Horário:\n${DateTimeUtils.formatDateTimeRange(activity.startTime, activity.endTime)}',
                    style: const TextStyle(height: 1.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(AppIcons.category, color: AppColors.primary),
                const SizedBox(width: 8),
                Chip(label: Text(activity.type)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Biografia do Palestrante:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(activity.speakerBio, style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 32),
            Consumer<ActivitiesProvider>(
              builder: (context, provider, child) {
                if (!provider.isAdmin) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Ações Administrativas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivityFormScreen(activity: activity),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Editar Atividade'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmar exclusão'),
                                  content: Text('Tem certeza que deseja excluir "${activity.title}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                                      child: const Text('Excluir'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                provider.deleteActivity(activity.id);
                                Navigator.pop(context); // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar( // ignore: use_build_context_synchronously
                                  const SnackBar(content: Text('Atividade excluída com sucesso')),
                                );
                              }
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text('Excluir Atividade', style: TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<ActivitiesProvider>(
        builder: (context, provider, child) {
          final isFavorite = provider.favorites.contains(activity.id);
          return FloatingActionButton(
            onPressed: () {
              provider.toggleFavorite(activity.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isFavorite ? 'Removido dos favoritos' : 'Adicionado aos favoritos')),
              );
            },
            child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          );
        },
      ),
    );
  }
}