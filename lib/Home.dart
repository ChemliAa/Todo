import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_project/helpers/drawerNavigation.dart';
import 'package:task_management_project/todo.dart';

import 'models/Task.dart';
import 'models/TaskModel.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late taskProvider providerTask;

  @override
  void initState() {
    super.initState();
    providerTask = Provider.of<taskProvider>(context, listen: false);
    final User? user = FirebaseAuth.instance.currentUser;
    String? id = user?.uid;
    providerTask.initialize(id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My tasks'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      drawer: const DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const todo())),
        child: const Icon(Icons.add),
      ),
      body: Consumer<taskProvider>(
        builder: (context, providerTask, child) {
          return ListView.builder(
            itemCount: providerTask.tasksList.length,
            itemBuilder: (context, index) {
              final Task task = providerTask.tasksList[index];
              return Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  providerTask.delete(task.id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    ),
                    child: ListTile(
                      title: Text(
                        task.title.toUpperCase(), // Uppercase title
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.description),
                          Text(
                            'Date: ${task.date}',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            'Status: ${task.isFinished ? 'Completed' : 'Pending'}', // Display task status
                            style: TextStyle(
                              color: task.isFinished ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        _showEditFormDialog(context, task);
                      },
                      trailing: Checkbox(
                        value: task.isFinished,
                        onChanged: (value) {
                          setState(() {
                            task.isFinished = value!;
                            providerTask.update(task);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  _showEditFormDialog(BuildContext context, Task task) {
    final TextEditingController titleController = TextEditingController(text: task.title);
    final TextEditingController descriptionController = TextEditingController(text: task.description);
    final TextEditingController dateController = TextEditingController(text: task.date);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                task.title = titleController.text;
                task.description = descriptionController.text;
                task.date = dateController.text;
                await providerTask.update(task);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
