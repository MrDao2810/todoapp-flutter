import 'dart:convert';

import 'package:reorderables/reorderables.dart';
import 'package:flutter/material.dart';
import 'package:project_todoapp/search.dart';
import 'package:project_todoapp/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static String storageTodolist = 'todolist'; // MyApp.storageTodolist = 'key' : lấy key
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> todoList = [];
  List<Task> displayedTasks = [];
  String currentStatus = 'all';
  bool isChecked = false;
  int doneCount = 0;
  String searchQuery = '';

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        debugPrint(query);
        displayedTasks = displayedTasks
            .where((element) => element.content
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
        _saveTaskList();
      });
    }
  }
  // Save data SharedPreferences

  @override
  void initState() {
    super.initState();
    _fetchList();
  }
  // -- Save Data TaskList --
  Future _fetchList() async {
    List<Task> todoListTmp = [];
    final prefs = await SharedPreferences.getInstance();
    var test = jsonEncode(prefs.getString(MyApp.storageTodolist));
    List<dynamic> todoListDB = jsonDecode(jsonDecode(test));
    for (var task in todoListDB) {
      var taskNew = Task(status: false, content: "2");
      taskNew.fromJson(task);
      todoListTmp.add(taskNew);
    }
    setState(() {
      todoList = [...todoListTmp];
    });
  }
  Future<void> _saveTaskList() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    String todoListJson = jsonEncode(todoList);
    // set value
    await prefs.setString(MyApp.storageTodolist, todoListJson);
  }


  @override
  Widget build(BuildContext context) {

    if (currentStatus == 'undone') {
      displayedTasks = todoList.where((element) => !element.status).toList();
    } else if (currentStatus == 'done') {
      displayedTasks = todoList.where((element) => element.status).toList();
    } else {
      displayedTasks = todoList;
    }
    // Count Done
    doneCount = todoList.where((element) => element.status).toList().length;

    final taskListRows = List.generate(displayedTasks.length, (index) {
      final textDecoration = displayedTasks[index].status
          ? TextDecoration.lineThrough
          : TextDecoration.none;
      int taskIndex = todoList.indexOf(displayedTasks[index]);
      return ReorderableTableRow(
        key: ObjectKey(displayedTasks[index]),
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: displayedTasks[index].status,
                onChanged: (value) {
                  setState(() {
                    displayedTasks[index].status = !displayedTasks[index].status;
                    _saveTaskList();
                  });
                },
              ),
              Text(
                displayedTasks[index].content.toString(),
                style: TextStyle(
                  decoration: textDecoration,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (taskIndex > 0) {
                          var temp = todoList[taskIndex];
                          todoList[taskIndex] = todoList[taskIndex - 1];
                          todoList[taskIndex - 1] = temp;
                        }
                        _saveTaskList();
                      });
                    },
                    icon: const Icon(
                      Icons.upload_sharp,
                      color: Colors.redAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (taskIndex < todoList.length - 1) {
                          var temp = todoList[taskIndex];
                          todoList[taskIndex] = todoList[taskIndex + 1];
                          todoList[taskIndex + 1] = temp;
                          _saveTaskList();
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.file_download_sharp,
                      color: Colors.redAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        todoList.removeAt(taskIndex);
                        _saveTaskList();
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        oldIndex = todoList.indexOf(displayedTasks[oldIndex]);
        newIndex = todoList.indexOf(displayedTasks[newIndex]);
        if(oldIndex >= 0 && newIndex >= 0) {
          final temp = todoList[oldIndex];
          todoList[oldIndex] = todoList[newIndex];
          todoList[newIndex] = temp;
        }
        _saveTaskList();
      });
    }

    Widget titleSection = Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'User Info',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    Color color = Theme.of(context).primaryColor;

    Widget _generateButton({required String value, required int taskCount}) {
      const normalColor = Colors.blue;
      const activeColor = Colors.deepOrange;
      return Container(
        margin: const EdgeInsets.all(10),
        // ignore: deprecated_member_use
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: currentStatus == value
                ? activeColor
                : normalColor, // background
            onPrimary: Colors.white, // foreground
          ),
          onPressed: () {
            setState(() {
              currentStatus = value;
              _saveTaskList();
            });
          },
          child: Text('$value $taskCount'),
        ),
      );
    }

    // Start -- Create button task-filter --
    Widget taskFilter = Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          _generateButton(value: 'all', taskCount: todoList.length),
          _generateButton(value: 'done', taskCount: doneCount),
          _generateButton(
              value: 'undone', taskCount: todoList.length - doneCount)
        ],
      ),
    );

    // End -- Create button task-filter --

    Widget searchBar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: SearchTask(onChange: _handleSearch),
    );

    // End -- Create input Search bar --

    // Start -- Create Task list --
    TextEditingController addTaskText = TextEditingController();
    Widget taskList = Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            controller: addTaskText,
            decoration: const InputDecoration(
              hintText: 'Add Task',
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            // ignore: deprecated_member_use
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                setState(() {
                  Task task =
                      Task(status: isChecked, content: addTaskText.text);
                  if (addTaskText.text != '') {
                    todoList.add(task);
                  }
                  _saveTaskList();
                });
              },
              child: const Text('Add'),
            ),
          ),
          ReorderableTable(
            onReorder: _onReorder,
            children: taskListRows,
          ),
        ],
      ),
    );
    // End -- Create Task list --

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            // titleSection,
            taskFilter,
            searchBar,
            taskList,
          ],
        ),
      ),
    );
  }
}

