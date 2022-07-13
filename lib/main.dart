
import 'package:flutter/material.dart';

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

// Object Task
class Task{ //modal class for Person object
  bool status;
  String content;
  Task({required this.status, required this.content});
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Task> todoList = [];
  bool isChecked = false;
  int count = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Count Done
    count = 0;
    for (var task in todoList) {
      if(task.status) {
        count++;
      }
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

    // Start -- Create button task-filter --
    Widget taskFilter = Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            // ignore: deprecated_member_use
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () { },
              child: Text('Total ${todoList.length}'),
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
              onPressed: () { },
              child: Text('Done $count'),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () { },
              child: Text('Not Done ${todoList.length - count}'),
            ),
          ),
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
              border: OutlineInputBorder(),
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
            children: List.generate(todoList.length, (index) {
              return ListTile(
                // Create checkBox
                leading: Checkbox(
                  value: todoList[index].status,
                  onChanged: (value) {
                    setState((){
                      todoList[index].status = !todoList[index].status;
                    });
                  },
                ),
                // Text TaskList
                title: Text(todoList[index].content.toString(),),
                // Create delete TaskList
                trailing: GestureDetector(
                  onTap: () {
                    setState((){
                      todoList.removeAt(index);
                    });
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.blue,
                  ),
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
            titleSection,
            taskFilter,
            searchBar,
            taskList,
          ],
        ),
      ),
    );
  }
}
