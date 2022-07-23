import 'package:bloc/bloc.dart';
import 'package:firstproject/shared/cubit/states.dart';
import 'package:firstproject/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  int currentIndex = 0;
  Database? dataBase;

  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);
  ThemeMode appMode = ThemeMode.dark;



  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNabBarStates());
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
  }
}
