import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kenyanvalley/core/widgets/error_widget.dart';
import 'package:kenyanvalley/core/widgets/loading_widget.dart';
import 'package:kenyanvalley/features/notes/data/models/note_model.dart';
import 'package:kenyanvalley/features/notes/presentation/providers/notes_provider.dart';
import 'package:kenyanvalley/features/notes/presentation/screens/note_editor_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteDetailScreen extends StatefulWidget {
  final String noteId;

  const NoteDetailScreen({
    super.key,
    required this.noteId,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late final NotesProvider _notesProvider;
  late Note? _note;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _notesProvider = context.read<NotesProvider>();
    _loadNote();
  }

  Future<void> _loadNote() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final note = await _notesProvider.getNoteById(widget.noteId);
      setState(() {
        _note = note;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        actions: [
          if (_note != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteEditorScreen(note: _note),
                  ),
                ).then((_) {
                  // Refresh the note after editing
                  _loadNote();
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: LoadingWidget())
          : _error != null
              ? Center(
                  child: ErrorMessageWidget(
                    message: _error!,
                    onRetry: _loadNote,
                  ),
                )
              : _note == null
                  ? const Center(child: Text('Note not found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _note!.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Created: ${_formatDate(_note!.createdAt)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (_note!.updatedAt != null)
                            Text(
                              'Updated: ${_formatDate(_note!.updatedAt!)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          const Divider(height: 32),
                          Text(
                            _note!.content,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (_note!.tags.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              children: _note!.tags
                                  .map((tag) => Chip(
                                        label: Text(tag),
                                        backgroundColor:
                                            Theme.of(context).colorScheme.primaryContainer,
                                      ))
                                  .toList(),
                            ),
                          ],
                          if (_note!.attachments.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Attachments:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            ..._note!.attachments.map((attachment) {
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.attachment),
                                  title: Text(attachment.filename),
                                  subtitle: Text('${(attachment.size / 1024).toStringAsFixed(2)} KB'),
                                  onTap: () => _launchUrl(attachment.url),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Attachment'),
                                          content: const Text(
                                              'Are you sure you want to delete this attachment?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmed == true) {
                                        try {
                                          await _notesProvider.deleteAttachment(
                                            noteId: _note!.id,
                                            attachmentId: attachment.id,
                                          );
                                          // Refresh the note after deletion
                                          _loadNote();
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Failed to delete attachment: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ],
                      ),
                    ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
