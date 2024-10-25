import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'settings_screen.dart';

class ToDoListPage extends StatefulWidget {
  final Function(bool) onToggleTheme;

  ToDoListPage({required this.onToggleTheme});

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final List<String> _tasks = [];

  void _addTask(String task) {
    setState(() {
      _tasks.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(onToggleTheme: widget.onToggleTheme),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _tasks.isEmpty
                  ? Center(child: Text('No tasks available, add some tasks!'))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Checkbox(
                              value: false,
                              onChanged: (bool? value) {
                                // Handle task completion
                              },
                            ),
                            title: Text(
                              _tasks[index],
                              style: TextStyle(
                                decoration: false ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _tasks.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskScreen(onAddTask: _addTask),
                    ),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
