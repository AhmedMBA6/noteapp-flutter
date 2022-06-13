import 'package:flutter/material.dart';
import 'package:todo_app/controller/controller.dart';
import 'package:todo_app/model/note_model.dart';
class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // save data
   List<NoteModel> _todoList = [];
  DatabaseHandler? databaseHandler = DatabaseHandler.instance;

  // text field
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body:
        FutureBuilder<List<NoteModel>>(
          future: _getItems(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
              shrinkWrap: true,
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(_todoList[index].title!),
                    subtitle: Text(_todoList[index].description!),
                    trailing: GestureDetector(
                      child: const Icon(Icons.delete, color: Colors.grey),
                      onTap: () {
                        deletNote(NoteModel(title: _textFieldController.text,
                            description: _textEditingController.text));
                      },
                    ),
                    onTap: () {
                      debugPrint("Tapped");
                      NoteModel(title: _textFieldController.text,
                          description: _textEditingController.text);
                    },
                  ),
                );
              },
            )
                : snapshot.hasError
                ? const Text('Error')
                : const CircularProgressIndicator();
          },
        ),

      // add items to the to-do list
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: const Icon(Icons.add)),
    );
  }

  Future<void> _addTodoItem(NoteModel noteModel) async{
    print('add ${noteModel.toMap()}');
    await databaseHandler!.createNote(noteModel);

  }
  Future<void> deletNote(NoteModel noteModel) async{
    await databaseHandler!.deleteNote(noteModel);
  }


  // display a dialog for the user to enter items
  Future<Future> _displayDialog(BuildContext context) async {
    // alter the app state to show a dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: SizedBox(
              child: Column(
                children: [
                  TextFormField(
                    controller: _textFieldController,
                    decoration: const InputDecoration(hintText: "Enter The Title"),
                  ),
                  TextFormField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(hintText: "Enter your Note"),
                  )
                ],
              ),
            ),

            actions: <Widget>[
              // add button
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(NoteModel(title: _textFieldController.text, description: _textEditingController.text));
                },
              ),
              // Cancel button
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  // iterates through our todo list title
  Future<List<NoteModel>> _getItems() async{
    _todoList = await databaseHandler!.getAllNotes();
    return _todoList;
  }
}