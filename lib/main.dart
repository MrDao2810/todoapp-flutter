
import 'package:flutter/material.dart';
import 'package:project_todoapp/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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
  int _counter = 0;
  List<Task> todoList = [];
  String currentStatus = 'all';
  bool isChecked = false;
  int doneCount = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Task> displayedTasks;
    if (currentStatus == 'all') {
      displayedTasks = todoList;
    } else if (currentStatus == 'done') {
      displayedTasks = todoList.where((element) => element.status).toList();
    } else {
      displayedTasks = todoList.where((element) => !element.status).toList();
    }
    // Count Done
    doneCount = todoList.where((element) => element.status).toList().length;
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
            primary: currentStatus == value ? activeColor : normalColor, // background
            onPrimary: Colors.white, // foreground
          ),
          onPressed: () {
            setState(() {
              currentStatus = value;
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
          _generateButton(value: 'undone', taskCount: todoList.length - doneCount)
        ],
      ),
    );

    // End -- Create button task-filter --

    // Start -- Create input Search bar --
    Widget searchBar = const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Search Bar',
        ),
      ),
    );

    // End -- Create input Search bar --

    // Start -- Create Task list --
    TextEditingController valueTaskList = TextEditingController();
    Widget taskList = Container(
    padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
           TextField(
            controller: valueTaskList,
            decoration: const InputDecoration(
              hintText: 'Task List',
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
                  Task task = Task(status: isChecked, content: valueTaskList.text);
                  if (valueTaskList.text != '') {
                    todoList.add(task);
                  }
                });
              },
              child: const Text('Add'),
            ),
          ),
          Column(
            children: List.generate(displayedTasks.length, (index) {
              int taskIndex = todoList.indexOf(displayedTasks[index]);
              return ListTile(
                // Create checkBox
                leading: Checkbox(
                  value: displayedTasks[index].status,
                  onChanged: (value) {
                    setState(() {
                      displayedTasks[index].status = !displayedTasks[index].status;
                    });
                  },
                ),
                // Text TaskList
                title: Text(displayedTasks[index].content.toString(),),
                // Create delete TaskList
                trailing: Row(
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
                        });
                      },
                      icon: const Icon(
                        Icons.upload_sharp,
                        color: Colors.black54,
                      ),
                    ),
                    IconButton(onPressed: () {
                      setState(() {
                        if (taskIndex < todoList.length - 1) {
                          var temp = todoList[taskIndex];
                          todoList[taskIndex] = todoList[taskIndex + 1];
                          todoList[taskIndex + 1] = temp;
                        }
                      });
                    },
                      icon: const Icon(
                        Icons.file_download_sharp,
                        color: Colors.black54,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          todoList.removeAt(taskIndex);
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }),
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
