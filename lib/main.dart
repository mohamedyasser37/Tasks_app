import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tasks/cubit/bloc_observer.dart';

import 'home_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(const Tasks());
}

class Tasks extends StatelessWidget {
  const Tasks({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
