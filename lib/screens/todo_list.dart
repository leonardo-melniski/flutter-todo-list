import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/components/dismissible_card_task.dart';
import 'package:todo_list/models/Task.dart';

enum SortOption { Todos, Pendentes, Finalizados }

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  TextEditingController _controllerAddTask = TextEditingController();

  List<Task> _listTask = new List<Task>();
  List<Task> _showListTask;

  SortOption viewOptionSelected = SortOption.Todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tarefas'),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<SortOption>(
              icon: Icon(Icons.sort),
              onSelected: updateShowListTask,
              itemBuilder: (context) {
                return SortOption.values.map((option) {
                  return PopupMenuItem<SortOption>(
                      value: option,
                      child: Text(describeEnum(option),
                          style: option == viewOptionSelected
                              ? TextStyle(fontWeight: FontWeight.bold)
                              : TextStyle()));
                }).toList();
              },
            )
          ],
        ),
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                listViewTask(),
                textFieldTask(),
              ],
            ),
          ),
        ));
  }

  listViewTask() {
    updateShowListTask();
    return Expanded(
        child: ListView.builder(
      padding: EdgeInsets.only(top: 18),
      itemCount: _showListTask.length,
      itemBuilder: (context, index) {
        return DismissibleCardTask(
            index, _showListTask, removeTask, updateShowListTask);
      },
    ));
  }

  textFieldTask() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: 'Adicionar nova tarefa'),
              controller: _controllerAddTask,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.blueAccent,
            ),
            iconSize: 40,
            onPressed: () {
              debugPrint('pressed icon button');
              addTask(_controllerAddTask.text);
              _controllerAddTask.clear();
            },
          )
        ],
      ),
    );
  }

  void addTask(String text) {
    if (text == null) return;
    if (text.trim().isEmpty) return;
    setState(() {
      _listTask.add(Task(text));
    });
    updateShowListTask();
  }

  void removeTask(Task task) {
    setState(() {
      _listTask.remove(task);
    });
    updateShowListTask();
  }

  void updateShowListTask([SortOption option]) {
    if (option != null) viewOptionSelected = option;
    _listTask.sort((t1, t2) {
      int it1 = t1.checked ? 1 : 0;
      int it2 = t2.checked ? 1 : 0;
      return it1 - it2;
    });

    switch (viewOptionSelected) {
      case SortOption.Todos:
        setState(() {
          _showListTask = _listTask.toList();
        });
        break;
      case SortOption.Pendentes:
        setState(() {
          _showListTask = _listTask.where((task) => !task.checked).toList();
        });
        break;
      case SortOption.Finalizados:
        setState(() {
          _showListTask = _listTask.where((task) => task.checked).toList();
        });
        break;
    }
  }
}
