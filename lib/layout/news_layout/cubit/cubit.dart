import 'package:bloc/bloc.dart';
import 'package:firstproject/layout/news_layout/cubit/states.dart';
import 'package:firstproject/shared/network/remote/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../modules/news_app/business/business_screen.dart';
import '../../../../modules/news_app/science/science_screen.dart';
import '../../../../modules/news_app/sports/sports_screen.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialStates());

  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.business), label: 'Business'),
    const BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Sports'),
    const BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Science'),
  ];
  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    if (index == 1) {
      getSportsData();
    }
    if (index == 2) {
      getScienceData();
    }
    emit(NewsBottomNavStates());
  }

  void getBusinessData() {
    emit(NewsGetBusinessLoadingStates());
    DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'eg',
      'category': 'business',
      'apiKey': '7c0028f2201a43cda1d45e4e9f05092c',
    })!
        .then((value) {
      //  print(value.data.toString());
      business = value.data['articles'];
      print(business[0]['title']);
      emit(NewsGetBusinessSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsGetBusinessErrorState
        (error.toString()));
    });
  }

  List<dynamic> business = [];

  void getSportsData() {
    if (sports.length == 0) {
      emit(NewsGetSportsLoadingStates());
      DioHelper.getData(url: 'v2/top-headlines', query: {
        'country': 'eg',
        'category': 'sports',
        'apiKey': '7c0028f2201a43cda1d45e4e9f05092c',
      })!
          .then((value) {
        //  print(value.data.toString());
        sports = value.data['articles'];
        print(sports[0]['title']);
        emit(NewsGetSportsSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetSportsErrorState(error.toString()));
      });
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }

  List<dynamic> sports = [];

  List<dynamic> search = [];

  void getScienceData() {
    if (science.length == 0) {
      emit(NewsGetScienceLoadingStates());
      DioHelper.getData(url: 'v2/top-headlines', query: {
        'country': 'eg',
        'category': 'science',
        'apiKey': '7c0028f2201a43cda1d45e4e9f05092c',
      })!
          .then((value) {
        //  print(value.data.toString());
        science = value.data['articles'];
        print(science[0]['title']);
        emit(NewsGetScienceSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(NewsGetScienceErrorState(error.toString()));
      });
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  List<dynamic> science = [];

  void getSearchData(String value) {
    search = [];
    emit(NewsGetSearchLoadingStates());
    DioHelper.getData(url: 'v2/everything', query: {
      'q': value,
      'apiKey': '7c0028f2201a43cda1d45e4e9f05092c',
    })!
        .then((value) {
      //  print(value.data.toString());
      search = value.data['articles'];
      print(search[0]['title']);
      emit(NewsGetSearchSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }
}
