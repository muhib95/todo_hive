import 'package:flutter/material.dart';
import 'package:todo_hive/model/todo_model.dart';
import 'package:todo_hive/service/todo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoService todoService = TodoService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Todo> _todos = [];

  Future<void> loadTodos() async {
    final todos = await todoService.getTodos();
    setState(() {
      _todos=todos;
    });
  }

  @override
  void initState() {
    loadTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Task List',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //dialogue open
          _showAddDialog();
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:_todos.isEmpty?Center(child: Text('No Task List')): ListView.builder(
            itemCount: _todos.length,
            itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 2, bottom: 2),
                  child: Card(
                    child: ListTile(
                        onTap: () {
                          //Edit dialogue
                          _showEditDialog(_todos[index], index);
                        },
                        title: Text(_todos[index].title),
                        subtitle: Text(_todos[index].description),
                        trailing: Container(
                          width: 96,
                          child: Row(
                            children: [
                              Checkbox(
                                value: _todos[index].isCompleted,
                                onChanged: (value) {
                                  setState(() {
                                    final todo = _todos[index];
                                    todo.isCompleted = value!;
                                    //Set toggle value update hive db
                                    todoService.updateTodo(index, todo);
                                  });
                                },
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await todoService.deleteTodo(index);
                                    loadTodos();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        )),
                  ),
                );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showAddDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task '),
          content: SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: 'Title'),
                  controller: _titleController,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: 'Description'),
                  controller: _descriptionController,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  DateTime t = DateTime.now();
                  final data = Todo(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      createdAt: t,
                      isCompleted: false);
                  print('todo: $data');
                  await todoService.addToDo(data);
                  _titleController.clear();
                  _descriptionController.clear();
                  await loadTodos();
                  Navigator.pop(context);
                },
                child: const Text('Add')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(Todo todo, int index) async {
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: 'Title'),
                  controller: _titleController,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: 'Description'),
                  controller: _descriptionController,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  DateTime t = DateTime.now();
                  final data = Todo(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      createdAt: t,
                      isCompleted: todo.isCompleted == true && !todo.isCompleted);
                  print('todo: $data');
                  await todoService.updateTodo(index, data);
                  _titleController.clear();
                  _descriptionController.clear();
                  await loadTodos();
                  Navigator.pop(context);
                },
                child: const Text('Update')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
          ],
        );
      },
    );
  }
}
