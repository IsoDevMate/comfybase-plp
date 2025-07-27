import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kenyanvalley/core/widgets/error_widget.dart';
import 'package:kenyanvalley/core/widgets/loading_widget.dart';
import 'package:kenyanvalley/features/notes/data/models/note_model.dart';
import 'package:kenyanvalley/features/notes/presentation/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagController;
  final Set<String> _tags = {};
  bool _isPrivate = true;
  bool _isLoading = false;
  String? _error;
  
  final List<File> _newAttachments = [];
  final List<String> _removedAttachmentIds = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _tagController = TextEditingController();
    _isPrivate = widget.note?.isPrivate ?? true;
    _tags.addAll(widget.note?.tags ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    
    if (pickedFile != null) {
      setState(() {
        _newAttachments.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      
      if (widget.note == null) {
        // Create new note
        await notesProvider.createNote(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          tags: _tags.toList(),
          isPrivate: _isPrivate,
        );
      } else {
        // Update existing note
        if (widget.note?.id != null) {
          await notesProvider.updateNote(
            id: widget.note!.id!,
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
            tags: _tags.toList(),
            isPrivate: _isPrivate,
          );
          
          // Handle removed attachments
          for (final attachmentId in _removedAttachmentIds) {
            await notesProvider.deleteAttachment(
              noteId: widget.note!.id!,
              attachmentId: attachmentId,
            );
          }
          
          // Handle new attachments
          for (final file in _newAttachments) {
            await notesProvider.addMediaAttachment(
              noteId: widget.note!.id!,
              filePath: file.path,
            );
          }
        }
      }
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    final attachments = [
      ...?note?.attachments,
      ..._newAttachments.map((file) => MediaAttachment(
        id: 'local-${file.path}',
        type: 'image',
        url: file.path,
        caption: '',
        createdAt: DateTime.now(),
      )),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveNote,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: LoadingWidget())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null) ...[
                      ErrorMessageWidget(message: _error!),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 8,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter some content';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tagController,
                            decoration: const InputDecoration(
                              labelText: 'Add a tag',
                              border: OutlineInputBorder(),
                            ),
                            onFieldSubmitted: (_) => _addTag(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addTag,
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _tags.map((tag) => Chip(
                        label: Text(tag),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => _removeTag(tag),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Private'),
                        Switch(
                          value: _isPrivate,
                          onChanged: (value) {
                            setState(() {
                              _isPrivate = value;
                            });
                          },
                        ),
                        const Text('Public'),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.photo_library),
                          onPressed: _pickImage,
                          tooltip: 'Add image',
                        ),
                      ],
                    ),
                    if (attachments.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Attachments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: attachments.length,
                          itemBuilder: (context, index) {
                            final attachment = attachments[index];
                            final isLocal = attachment.id.startsWith('local-');
                            
                            return Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: isLocal
                                      ? Image.file(
                                          File(attachment.url),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          attachment.url,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => 
                                              const Icon(Icons.broken_image),
                                        ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, size: 16, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        if (isLocal) {
                                          _newAttachments.removeWhere((file) => 
                                              'local-${file.path}' == attachment.id);
                                        } else {
                                          _removedAttachmentIds.add(attachment.id);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
