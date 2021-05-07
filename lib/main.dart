import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();

  List<String> todoList = [];

  bool isDeleteMode = false;

  final Set<int> checked = {};

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Expanded(child: Text('할일 목록')),
        actions: isDeleteMode ? deleteModeActions : normalModeActions,
      ),
      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: todoList
              .asMap()
              .entries
              .map((e) => ListTile(
                  leading: isDeleteMode
                      ? Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              if (value) {
                                checked.add(e.key);
                              } else {
                                checked.remove(e.key);
                              }
                            });
                          },
                          value: checked.contains(e.key),
                        )
                      : null,
                  title: Text(e.value)))
              .toList(),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> normalModeActions = [];
  List<Widget> deleteModeActions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    normalModeActions = [
      IconButton(
          icon: Icon(Icons.remove_circle_outline_sharp),
          onPressed: () {
            setState(() {
              isDeleteMode = true;
            });
          }),
    ];
    deleteModeActions = [
      IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            setState(() {
              isDeleteMode = false;
              checked.clear();
            });
          }),
      IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            setState(() {
              isDeleteMode = false;
              todoList = todoList
                  .asMap()
                  .entries
                  .where((e) => !checked.contains(e.key))
                  .map((e) => e.value)
                  .toList();
              checked.clear();
            });
          })
    ];
  }

  void _addTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("할 일"),
          content: TextField(
            controller: _controller,
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Add"),
              onPressed: () {
                setState(() {
                  if(_controller.text.isEmpty) {
                    return;
                  }
                  todoList.add(_controller.text);

                  _controller.text = '';
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
