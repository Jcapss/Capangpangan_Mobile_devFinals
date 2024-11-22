import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'settings_screen.dart';

class Task {
  String description;
  String priority;
  bool isCompleted;

  Task(this.description, this.priority, {this.isCompleted = false});
}

class ToDoListPage extends StatefulWidget {
  final Function(bool) onToggleTheme;

  ToDoListPage({required this.onToggleTheme});

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final List<Task> _tasks = [];

  void _addTask(String description, String priority) {
    setState(() {
      _tasks.add(Task(description, priority));
      _sortTasksByPriority();
    });
  }

  void _editTask(int index, String newDescription, String newPriority) {
    setState(() {
      _tasks[index].description = newDescription;
      _tasks[index].priority = newPriority;
      _sortTasksByPriority();
    });
  }

  void _sortTasksByPriority() {
    const priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
    _tasks.sort((a, b) =>
        priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsScreen(onToggleTheme: widget.onToggleTheme),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _tasks.isEmpty
                  ? Center(child: Text('No tasks available, add some tasks!'))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Checkbox(
                              value: task.isCompleted,
                              onChanged: (bool? value) {
                                setState(() {
                                  task.isCompleted = value!;
                                });
                              },
                            ),
                            title: Text(
                              task.description,
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text('Priority: ${task.priority}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _showEditTaskDialog(context, task, index);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _tasks.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
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
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task, int index) {
    final TextEditingController descriptionController =
        TextEditingController(text: task.description);
    String selectedPriority = task.priority;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                items: ['High', 'Medium', 'Low']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedPriority = value!;
                },
                decoration: InputDecoration(labelText: 'Priority'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _editTask(
                  index,
                  descriptionController.text,
                  selectedPriority,
                );
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
