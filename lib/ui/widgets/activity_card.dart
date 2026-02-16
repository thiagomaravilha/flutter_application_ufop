import 'package:flutter/material.dart';
import '../../models/activity_model.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../screens/activity_details_screen.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final bool showAdminActions;
  final IconData? leadingIcon;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ActivityCard({
    super.key,
    required this.activity,
    this.showAdminActions = false,
    this.leadingIcon,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.primary, width: 4),
      ),
      child: ListTile(
        leading: Icon(leadingIcon ?? AppIcons.event, color: AppColors.primary),
        title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${activity.speakerName} - ${activity.location}'),
            Text(DateTimeUtils.formatActivityTime(activity.startTime, activity.endTime), style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: showAdminActions
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.secondary),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                  Chip(label: Text(activity.type, style: const TextStyle(fontSize: 10))),
                ],
              )
            : Chip(label: Text(activity.type, style: const TextStyle(fontSize: 10))),
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
  }
}