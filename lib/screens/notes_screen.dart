import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/campus_note.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({required this.appState, super.key});

  final CampusBuddyState appState;

  Future<void> _addNote(BuildContext context) async {
    final note = await Navigator.of(context).push<CampusNote>(
      MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
    );
    if (note != null) appState.addNote(subject: note.subject, body: note.body);
  }

  Future<void> _editNote(BuildContext context, int index) async {
    final note = await Navigator.of(context).push<CampusNote>(
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(note: appState.notes[index]),
      ),
    );
    if (note != null) appState.updateNoteAt(index, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addNote(context),
        icon: const Icon(Icons.add),
        label: const Text('New note'),
      ),
      body: appState.notes.isEmpty
          ? const Center(child: Text('No notes yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appState.notes.length,
              itemBuilder: (context, index) {
                final note = appState.notes[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.sticky_note_2_outlined),
                    title: Text(note.subject),
                    subtitle: Text(
                      note.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') _editNote(context, index);
                        if (value == 'delete') appState.removeNoteAt(index);
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                    onTap: () => _editNote(context, index),
                  ),
                );
              },
            ),
    );
  }
}

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({this.note, super.key});

  final CampusNote? note;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _subjectController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(
      text: widget.note?.subject ?? '',
    );
    _bodyController = TextEditingController(text: widget.note?.body ?? '');
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _save() {
    if (_subjectController.text.trim().isEmpty &&
        _bodyController.text.trim().isEmpty) {
      return;
    }
    Navigator.of(context).pop(
      CampusNote(
        subject: _subjectController.text.trim(),
        body: _bodyController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New note' : 'Edit note'),
        actions: [IconButton(onPressed: _save, icon: const Icon(Icons.check))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _subjectController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Subject'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyController,
            maxLines: 10,
            decoration: const InputDecoration(
              labelText: 'Note',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Save note'),
          ),
        ],
      ),
    );
  }
}
