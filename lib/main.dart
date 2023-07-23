import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dhanvine's Notes App",
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LoginPage(), // Show LoginPage at first
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void _login() {
      // Validate username and password here (add authentication logic later)
      String username = usernameController.text;
      String password = passwordController.text;
      if (username.isNotEmpty && password.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotesHomePage(username, password)),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Invalid username or password.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  final String username;
  final String password;

  NotesHomePage(this.username, this.password);

  @override
  _NotesHomePageState createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  List<Note> notesList = [];

  void _addNote() {
    String newTitle = '';
    String newDescription = '';
    DateTime newDueDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newTitle = value;
                },
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onChanged: (value) {
                  newDescription = value;
                },
                decoration: InputDecoration(labelText: 'Description'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Show a date picker to select the due date
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)), // Allow up to one year in the future
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        newDueDate = selectedDate;
                      });
                    }
                  });
                },
                child: Text('Select Due Date pwease'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  notesList.add(Note(
                    title: newTitle,
                    description: newDescription,
                    dueDate: newDueDate,
                  ));
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
    Note editedNote = notesList[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  editedNote.title = value;
                },
                controller: TextEditingController(text: editedNote.title),
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onChanged: (value) {
                  editedNote.description = value;
                },
                controller: TextEditingController(text: editedNote.description),
                decoration: InputDecoration(labelText: 'Description'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Show a date picker to select the due date
                  showDatePicker(
                    context: context,
                    initialDate: editedNote.dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)), // Allow up to one year in the future
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      setState(() {
                        editedNote.dueDate = selectedDate;
                      });
                    }
                  });
                },
                child: Text('Select Due Date'),
              ),
            ],
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
        title: Text('Dhanvine\'s Notes App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100, // Adjust the height as per preference
              color: Colors.deepOrange,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Close the drawer and navigate to the profile page
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(widget.username, widget.password)),
                );
              },
            ),
          ],
        ),
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
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}

class Note {
  String title;
  String description;
  DateTime dueDate;

  Note({
    required this.title,
    required this.description,
    required this.dueDate,
  });
}

class NoteCard extends StatefulWidget {
  final Note note;
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
              title: Text(widget.note.title),
              subtitle: Text(widget.note.description),
              trailing: Text("Due: ${widget.note.dueDate.toLocal().toString().split(' ')[0]}"),
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

class ProfilePage extends StatelessWidget {
  final String username;
  final String password;

  ProfilePage(this.username, this.password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("________picture here later________"),
            Text('Username: ${username}'),
            SizedBox(height: 16.0),
            Text('Password: ${password}'),
            // Add more account details here later
          ],
        ),
      ),
    );
  }
}
