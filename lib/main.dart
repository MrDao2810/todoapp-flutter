
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
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
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(25),
            // ignore: deprecated_member_use
            child: FlatButton(
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {},
              child: const Text('Total',
                style: TextStyle(fontSize: 20.0),),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25),
            // ignore: deprecated_member_use
            child: FlatButton(
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {},
              child: const Text('Done',
                style: TextStyle(fontSize: 20.0),),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25),
            // ignore: deprecated_member_use
            child: FlatButton(
              color: Colors.blueAccent,
              textColor: Colors.white,
              onPressed: () {},
              child: const Text('Not Done',
                style: TextStyle(fontSize: 20.0),),
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
    Widget taskList = Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Task List',
            ),
          ),
          Row(
            children: const [
              Text('Hello Phong!')
            ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
