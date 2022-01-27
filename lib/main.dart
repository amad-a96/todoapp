import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'todo_screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() async {
  final bool isConnected = await InternetConnectionChecker().hasConnection;

  if (isConnected) {
    print("conect");
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  } else
    print("false");

  runApp(const MyApp( ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  TodoApp(),
    );
  }
}

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoScreen(),
    );
  }
}
