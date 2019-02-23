import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_todo_app/bloc/todo_bloc.dart';
import 'package:reactive_todo_app/model/todo.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final TodoBloc todoBloc = TodoBloc();
  final String title;

  //Allows Todo card to be dismissable horizontally
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.3),
                )),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.indigoAccent,
                      size: 28,
                    ),
                    onPressed: () {
                      todoBloc.getTodos();
                    }),
                Expanded(
                  child: Text(
                    "Todo",
                    style: TextStyle(
                        //color: Colors.tealAccent,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'RobotoMono',
                        fontStyle: FontStyle.italic,
                        fontSize: 18),
                  ),
                ),
                Wrap(children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.indigoAccent,
                    ),
                    onPressed: () {
                      _showTodoSearchSheet(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                  )
                ])
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
              child: Container(
                  child: getTodosWidget())
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 25),
          child: FloatingActionButton(
            elevation: 5.0,
            onPressed: () {
              _showAddTodoSheet(context);
            },
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              size: 32,
              color: Colors.tealAccent,
            ),
          ),
        ));
  }

  void _showAddTodoSheet(BuildContext context) {
    final _todoDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _todoDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                  hintText: 'I have to...',
                                  labelText: 'New Todo',
                                  labelStyle: TextStyle(
                                      color: Colors.indigoAccent,
                                      fontWeight: FontWeight.w500)),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Empty description!';
                                }
                                return value.contains('')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.indigoAccent,
                              radius: 18,
                              child: IconButton(
                                icon: Icon(
                                  Icons.save,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final newTodo = Todo(
                                      description:
                                      _todoDescriptionFormController
                                          .value.text);
                                  if (newTodo.description.isNotEmpty) {
                                    todoBloc.addTodo(newTodo);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showTodoSearchSheet(BuildContext context) {
    final _todoSearchDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: new Container(
              color: Colors.transparent,
              child: new Container(
                height: 230,
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _todoSearchDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Description search...',
                                labelText: 'Search from the Backend *',
                                labelStyle: TextStyle(
                                    color: Colors.indigoAccent,
                                    fontWeight: FontWeight.w500),
                              ),
                              validator: (String value) {
                                return value.contains('@')
                                    ? 'Do not use the @ char.'
                                    : null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.indigoAccent,
                              radius: 18,
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  todoBloc.getTodos(
                                      query:
                                      _todoSearchDescriptionFormController
                                          .value.text);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget noInternetWidget() {
    return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.network_check), iconSize: 45, onPressed: null),
              Text(
                "No Internet",
                style: TextStyle(fontSize: 19),
              ),
            ],
          ),
        ));
  }

  Widget getTodosWidget() {
    return StreamBuilder(
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Todo>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data.length != 0
          ? ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, itemPosition) {
          Todo todo = snapshot.data[itemPosition];
          final Widget dismissibleCard = new Dismissible(
            background: Container(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Deleting",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              color: Colors.redAccent,
            ),
            onDismissed: (direction) {
              todoBloc.deleteTodoById(todo.id);
            },
            direction: _dismissDirection,
            key: new ObjectKey(todo),
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[200], width: 0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: InkWell(
                    onTap: () {
                      todo.isDone = !todo.isDone;
                      todoBloc.updateTodo(todo);
                    },
                    child: Container(
                      //decoration: BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: todo.isDone
                            ? Icon(
                          Icons.done,
                          size: 26.0,
                          //color: Colors.tealAccent,
                        )
                            : Icon(
                          Icons.check_box_outline_blank,
                          size: 26.0,
                          //color: Colors.tealAccent,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    todo.description,
                    style: TextStyle(
                        fontSize: 16.5,
                        fontFamily: 'RobotoMono',
                        fontWeight: FontWeight.w500,
                        decoration: todo.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                )),
          );
          return dismissibleCard;
        },
      )
          : Container(
          child: Center(
            child: noTodoMessageWidget(),
          ));
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    //pull todos again
    todoBloc.getTodos();
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[CircularProgressIndicator(), Text("Loading...")],
        ),
      ),
    );
  }

  Widget noTodoMessageWidget() {
    return Container(
      child: Text(
        "Start adding Todo...",
        style: TextStyle(fontSize: 19),
      ),
    );
  }

  dispose() {
    todoBloc.dispose();
  }
}
