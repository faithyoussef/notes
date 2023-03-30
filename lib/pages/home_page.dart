import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> todos = [];
  final TitleController = TextEditingController();
  final DescriptionController = TextEditingController();
  @override
  void dispose() {
    TitleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _databaseInit();
    super.initState();
  }

  _databaseInit() async {
    print(await getDatabasesPath());
    final database = openDatabase(
      join(await getDatabasesPath(), 'todos_database.db'),
      onCreate: (db, version) async {
        return db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, description TEXT);',
        );
      },
      version: 1,
    );
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    for (var map in maps) {
      map = {
        'title': map['title'],
        'description': map['description'],
      };

      setState(() {
        todos.add(map);
      });
    }
  }

  _databaseInsert() async {
    print(await getDatabasesPath());
    final database = openDatabase(
      join(await getDatabasesPath(), 'todos_database.db'),
      version: 1,
    );
    final db = await database;
    await db.delete('todos');
    for (var i = 0; i < todos.length; i++) {
      await db.insert(
        'todos',
        {
          'title': todos[i]['title'],
          'description': todos[i]['description'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.white38,
        centerTitle: true,
        bottom: PreferredSize(
          child: Container(
            color: Colors.green,
            height: 0.9,
          ),
          preferredSize: const Size.fromHeight(0.9),
        ),
      ),
      body: Center(
        child: TodoList(
          todos: todos,
          function: _databaseInsert,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              TitleController.clear();
              DescriptionController.clear();
              return AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                title: const Text("New note"),
                content: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: TitleController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        strutStyle: StrutStyle.disabled,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: DescriptionController,
                        autofocus: true,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 4,
                        strutStyle: StrutStyle.disabled,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            todos.add({
                              'title': TitleController.text,
                              'description': DescriptionController.text,
                            });
                            _databaseInsert();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add_home_work_rounded),
        tooltip: 'New todo',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
