import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesHomePage(),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  @override
  _NotesHomePageState createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  List<String> notesList = [];

  void _addNote() {
    String newNote = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: TextField(
            onChanged: (value) {
              newNote = value;
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  notesList.add(newNote);
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editNote(int index) {
    String editedNote = notesList[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: TextField(
            onChanged: (value) {
              editedNote = value;
            },
            controller: TextEditingController(text: editedNote),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  notesList[index] = editedNote;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(int index) {
    setState(() {
      notesList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                return NoteCard(
                  note: notesList[index],
                  onEdit: () => _editNote(index),
                  onDelete: () => _deleteNote(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class NoteCard extends StatefulWidget {
  final String note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  NoteCard({required this.note, required this.onEdit, required this.onDelete});

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool _isActionsVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isActionsVisible = !_isActionsVisible;
        });
      },
      child: Stack(
        children: [
          Card(
            elevation: 4.0,
            child: ListTile(
              title: Text(widget.note),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: AnimatedOpacity(
              opacity: _isActionsVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: widget.onEdit,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
          ),
        ],
        alignment: Alignment.centerRight,
      ),
    );
  }
}
