import 'package:flutter/material.dart';

void main() {
  runApp(TaskChartApp());
}

class TaskChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class Task {
  final String title;
  final String priority;
  String status;

  Task({required this.title, required this.priority, this.status = 'Not Started'});
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  void _addTask(String title, String priority) {
    setState(() {
      tasks.add(Task(title: title, priority: priority));
    });
  }

  void _updateTaskStatus(int index, String status) {
    setState(() {
      tasks[index].status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].title),
            trailing: DropdownButton<String>(
              value: tasks[index].status,
              onChanged: (value) {
                _updateTaskStatus(index, value!);
              },
              items: <String>['Not Started', 'In Progress', 'Completed']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            leading: CircleAvatar(
              backgroundColor: _getColorForPriority(tasks[index].priority),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskDisplayScreen(tasks: tasks)),
              );
            },
            child: Icon(Icons.view_list),
            heroTag: null,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  String title = '';
                  String priority = 'Low';
                  return AlertDialog(
                    title: Text('Add Task'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {
                            title = value;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Task Title',
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          value: priority,
                          onChanged: (value) {
                            priority = value!;
                          },
                          items: <String>['Low', 'Medium', 'High'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _addTask(title, priority);
                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add),
            heroTag: null,
          ),
        ],
      ),
    );
  }

  Color _getColorForPriority(String priority) {
    switch (priority) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.yellow;
      case 'High':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class TaskDisplayScreen extends StatelessWidget {
  final List<Task> tasks;

  const TaskDisplayScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<Task>> tasksByStatus = {
      'Not Started': [],
      'In Progress': [],
      'Completed': [],
    };

    for (Task task in tasks) {
      tasksByStatus[task.status]!.add(task);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Display'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
      ),
      body: Row(
        children: tasksByStatus.entries.map((entry) {
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      Task task = entry.value[index];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text('Priority: ${task.priority}'),
                        leading: CircleAvatar(
                          backgroundColor: _getColorForPriority(task.priority),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getColorForPriority(String priority) {
    switch (priority) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.yellow;
      case 'High':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class TaskChartScreen extends StatelessWidget {
  final List<Task> tasks;

  const TaskChartScreen({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<Task>> chartData = {
      'Not Started': [],
      'In Progress': [],
      'Completed': [],
    };

    for (Task task in tasks) {
      chartData[task.status]!.add(task);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Chart'),
      ),
      body: Row(
        children: chartData.entries.map((entry) {
          return Expanded(
            child: Column(
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(entry.value[index].title),
                        leading: CircleAvatar(
                          backgroundColor: _getColorForPriority(entry.value[index].priority),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskListScreen()),
          );
        },
        child: Icon(Icons.list),
      ),
    );
  }

  Color _getColorForPriority(String priority) {
    switch (priority) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.yellow;
      case 'High':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}