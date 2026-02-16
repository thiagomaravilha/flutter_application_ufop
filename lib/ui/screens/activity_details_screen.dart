import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/activities_provider.dart';
import '../../models/activity_model.dart';

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
            Text('Palestrante: ${activity.speakerName}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Descrição: ${activity.description}'),
            const SizedBox(height: 8),
            Text('Local: ${activity.location}'),
            const SizedBox(height: 8),
            Text('Horário: ${DateFormat('dd/MM - HH:mm').format(activity.startTime)} - ${DateFormat('HH:mm').format(activity.endTime)}'),
            const SizedBox(height: 8),
            Text('Tipo: ${activity.type}'),
            const SizedBox(height: 16),
            Text('Biografia: ${activity.speakerBio}'),
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