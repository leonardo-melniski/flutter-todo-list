import 'package:flutter/material.dart';
import 'package:todo_list/models/Task.dart';

class DismissibleCardTask extends StatelessWidget {
  final List<Task> tasks;
  final int index;
  final Function toDelete;
  final Function updateChecked;

  DismissibleCardTask(this.index, this.tasks, this.toDelete, this.updateChecked);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(tasks[index]),
      child: CardTask(index, tasks, toDelete, updateChecked),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          toDelete(tasks[index]);
        }
      },
      confirmDismiss: (direction) => dialogToDelete(context, tasks[index]),
      background: Container(
        alignment: Alignment(0.9, 0),
        color: Colors.red,
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
    );
  }
}

Future<bool> dialogToDelete(BuildContext context, Task task) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Tem certeza que deseja remover a tarefa '${task.text}'?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("REMOVER",style: TextStyle(color: Colors.red),),),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("CANCELAR"),
              ),
            ],
          );
        } ??
        false,
  );
}

class CardTask extends StatefulWidget {
  final List<Task> tasks;
  final int index;
  final Function toDelete;
  final Function updateChecked;

  CardTask(this.index, this.tasks, this.toDelete, this.updateChecked);

  @override
  _CardTaskState createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(children: <Widget>[
      IconButton(
        icon: Icon(
          widget.tasks[widget.index].checked
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
        ),
        onPressed: () {
          setState(() {
            widget.tasks[widget.index].checked =
                !widget.tasks[widget.index].checked;
            widget.updateChecked();
          });
        },
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Text(widget.tasks[widget.index].text,
              style: widget.tasks[widget.index].checked
                  ? TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      decoration: TextDecoration.lineThrough)
                  : TextStyle(
                      fontSize: 16,
                    )),
        ),
      ),
//      IconButton(
//        icon: Icon(Icons.delete_outline),
//        onPressed: () async {
//          var value = await dialogToDelete(context);
//          if (value) {
//            print('confirm delete');
//            widget.toDelete(widget.index);
//          } else {
//            print('cancel delete');
//          }
//        },
//      )
    ]));
  }
}
