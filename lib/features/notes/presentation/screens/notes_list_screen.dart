import 'package:flutter/material.dart';
import 'package:kenyanvalley/core/widgets/error_widget.dart';
import 'package:kenyanvalley/core/widgets/loading_widget.dart';
import 'package:kenyanvalley/features/notes/data/models/note_model.dart';
import 'package:kenyanvalley/features/notes/presentation/providers/notes_provider.dart';
import 'package:kenyanvalley/features/notes/presentation/screens/note_editor_screen.dart';
import 'package:provider/provider.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NotesProvider>(context, listen: false);
      provider.refreshNotes();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    
    // Load more when scrolled to 80% of the list
    if (currentScroll >= (maxScroll * 0.8)) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final provider = Provider.of<NotesProvider>(context, listen: false);
    if (provider.hasReachedMax) return;
    
    setState(() {
      _isLoadingMore = true;
    });
    
    await provider.getNotes();
    
    if (mounted) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotesProvider>(context);
    final state = provider.state;
        
        return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NoteEditorScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refreshNotes();
            },
          ),
        ],
      ),
      body: _buildBody(provider, state),
    );
  }

  Widget _buildBody(NotesProvider provider, NotesState state) {
    if (state.isLoading && state.notes.isEmpty) {
      return const Center(child: LoadingWidget());
    }

    if (state.error != null && state.notes.isEmpty) {
      return Center(
        child: ErrorMessageWidget(
          message: state.error!.message,
          onRetry: () {
            provider.refreshNotes();
          },
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.refreshNotes(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8.0),
        itemCount: state.notes.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.notes.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          
          final note = state.notes[index];
          return _buildNoteCard(context, note);
        },
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditorScreen(note: note),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (note.isPrivate)
                    const Icon(Icons.lock_outline, size: 16)
                  else
                    const Icon(Icons.public, size: 16),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (note.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: note.tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            labelStyle: const TextStyle(fontSize: 12),
                            backgroundColor: Colors.grey[200],
                          ))
                      .toList(),
                ),
              ],
              if (note.attachments.isNotEmpty) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: note.attachments.length,
                    itemBuilder: (context, index) {
                      final attachment = note.attachments[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            attachment.url,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (note.sharedWith.isNotEmpty)
                    Text(
                      'Shared with ${note.sharedWith.length} people',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
