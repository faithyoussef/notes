import 'package:flutter/material.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    Key? key,
    required this.todos,
    required this.function,
  }) : super(key: key);
  final List<Map<String, dynamic>> todos;
  final ValueGetter function;
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TitleController = TextEditingController();
  final DescriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return widget.todos.isEmpty
        ? const Text('Create your very first idea!')
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: widget.todos.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        TitleController.text = widget.todos[index]['title'];
                        DescriptionController.text =
                            widget.todos[index]['description'];
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          title: const Text("Edit your note"),
                          content: Form(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 40),
                                TextFormField(
                                  controller: TitleController,
                                  autofocus: true,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  strutStyle: StrutStyle.disabled,
                                  decoration: InputDecoration(
                                    hintText: 'Title',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: DescriptionController,
                                  autofocus: true,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  maxLines: 4,
                                  strutStyle: StrutStyle.disabled,
                                  decoration: InputDecoration(
                                    hintText: 'Description',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.todos.removeAt(index);
                                      widget.todos.insert(index, {
                                        'title': TitleController.text,
                                        'description':
                                            DescriptionController.text,
                                      });
                                      widget.function();
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
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.surface,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(height: 40),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              widget.todos[index]['title'].toString(),
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 30,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.todos[index]['description'].toString(),
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            Map<String, dynamic> todo = widget.todos[index];
                            widget.todos.removeAt(index);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            widget.todos.remove(todo);
                            widget.function();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      widget.todos.insert(index, todo);
                                      widget.function();
                                    });
                                  },
                                ),
                                content: Row(
                                  children: [
                                    Text(
                                      todo['title'] + ' successfully deleted! ',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.delete,
                          size: 40,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }
}
