import 'package:reactive_todo_app/model/todo.dart';
import 'package:reactive_todo_app/repository/todo_repository.dart';


import 'dart:async';

class TodoBloc {
  //Get instance of the Repository
  final _todoRepository = TodoRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _todoController = StreamController<List<Todo>>.broadcast();

  get todos => _todoController.stream;

  TodoBloc() {
    getTodos();
  }

  getTodos({String query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event (stream transformation)
    _todoController.sink.add(await _todoRepository.getAllTodos(query: query));
  }

  addTodo(Todo todo) async {
    await _todoRepository.insertTodo(todo);
    getTodos();
  }

  updateTodo(Todo todo) async {
    await _todoRepository.updateTodo(todo);
    getTodos();
  }

  deleteTodoById(int id) async {
    _todoRepository.deleteTodoById(id);
    getTodos();
  }

  dispose() {
    _todoController.close();
  }
}
