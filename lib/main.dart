import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

main()=> runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _controller = new TextEditingController();

  List<String> todo = [];

  getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todo = prefs.getStringList('TODO')??[];
    });

  }

  saveData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('TODO', todo);
  }


  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('My TODO List'),),
        body: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3
                  ),

                  itemBuilder: (_,index){
                    return InkWell(
                      splashColor: Colors.blue,
                      highlightColor: Colors.lightGreen,
                      onLongPress: (){
                        setState(() {
                          todo.removeAt(todo.length - 1 - index);
                          saveData();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)
                        ),
                        child: Center(child: Text(todo[todo.length - 1 - index],style: TextStyle(fontSize: 20),)),
                      ),
                    );
                  },
                itemCount: todo.length??0,
              ),
            ),
            Card(

              elevation: 5,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter new TODO ...'
                    ),
                  ),
                  RaisedButton(
                    child: Text('Add TODO'),
                    onPressed: (){
                      if(_controller.text.isNotEmpty) {
                        setState(() {
                          todo.add(_controller.text);
                          _controller.clear();
                          saveData();
                        });
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
