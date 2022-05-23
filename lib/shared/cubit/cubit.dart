import 'package:bloc/bloc.dart';
import 'package:firstproject/modules/todo_app/archived_tasks/archived_tasks_screen.dart';
import 'package:firstproject/shared/cubit/states.dart';
import 'package:firstproject/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/todo_app/done_tasks/done_tasks_screen.dart';
import '../../modules/todo_app/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  int currentIndex = 0;
   Database? dataBase;

  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);
  ThemeMode appMode = ThemeMode.dark;

  List<Widget> screen = [
    const NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];

  List<String> LabelsTitle = [
    'Tasks',
    'Done',
    'Archived',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNabBarStates());
  }

  void createDataBase() async {
    dataBase = await openDatabase(
      'Todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('dataBase Created');
        print('dataBase Created');
        await database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT,time TEXT , status TEXT )');
      },
      onOpen: (database) {
        print('DataBase Opened');
      },
    );
  }

  bool isDark = false;

  void changeAppMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.setBoolean(key: 'isDark', value: isDark)!.then((value) {
        emit(AppChangeModeState());
      }).catchError((error) {
        print(error.toString());
      });
    }

    void insertDataBase({
      required String title,
      required String time,
      required String date,
    }) async {
      await dataBase!.transaction((txn) {
        return txn
            .rawInsert(
                'INSERT INTO tasks (title, date, time, status) VALUES("$title", "$time", "$date", "new")')
            .then((value) {
          print('$value inserted successfully');
        }).catchError((error) {
          print('Error When Inserting new record ${error.toString()}');
        });
      });
    }
  }
}
