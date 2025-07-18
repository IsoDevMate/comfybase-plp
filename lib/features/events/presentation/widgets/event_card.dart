import 'package:flutter/material.dart';
import '../../data/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;
  final VoidCallback? onRegister;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EventCard({
    Key? key,
    required this.event,
    this.onTap,
    this.onRegister,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.location.name),
            Text('${event.startDate.toLocal()} - ${event.endDate.toLocal()}'),
            if (event.status.isNotEmpty) Text('Status: ${event.status}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'register' && onRegister != null) onRegister!();
            if (value == 'edit' && onEdit != null) onEdit!();
            if (value == 'delete' && onDelete != null) onDelete!();
          },
          itemBuilder: (context) => [
            if (onRegister != null)
              const PopupMenuItem(value: 'register', child: Text('Register')),
            if (onEdit != null)
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
            if (onDelete != null)
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
