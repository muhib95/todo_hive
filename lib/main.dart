import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_hive/model/todo_model.dart';
import 'package:todo_hive/screens/home_screen.dart';
import 'package:todo_hive/service/todo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await TodoService().openBox();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
