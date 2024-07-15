import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks/archived_task_screen.dart';
import 'package:tasks/done_task_screen.dart';
import 'package:tasks/new_task_screen.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);
  bool isBottomSheetShown = false;

  int currentIndex = 0;
  var database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];



  List<String> text = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  List<Widget> screens = [
    const NewTaskScreen(),
    DoneTaskScreen(),
    const ArchivedTaskScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppBottomNavBarChange());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertDatabase(
      {required String title,
      required String date,
      required String time}) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      });
    });
  }

  void getDataFromDatabase(Database database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    database.rawQuery('SELECT * FROM tasks').then((value) {


      value.forEach((element) {
        if(element['status'] == 'new') {
          newTasks.add(element);
        }else if(element['status']=='done')
        {
          doneTasks.add(element);
        }else
        {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppIUpdateDatabaseState());
    });
  }


  void deleteDatabase({
    required int id,
  }) async {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void changeFabIcon() {
    isBottomSheetShown = !isBottomSheetShown;
    emit(AppFabChange());
  }
}
