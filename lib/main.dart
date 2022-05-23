import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firstproject/layout/news_layout/cubit/cubit.dart';
import 'package:firstproject/layout/news_layout/news_layout.dart';
import 'package:firstproject/layout/shop_layout/shop_layout.dart';
import 'package:firstproject/layout/social_app/social_layout.dart';
import 'package:firstproject/models/shop_app/search_model/cubit/cubit.dart';
import 'package:firstproject/modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:firstproject/modules/shop_app/register/cubit/cubit.dart';
import 'package:firstproject/modules/shop_app/shop_login/shop_login_screen.dart';
import 'package:firstproject/layout/social_app/cubit/cubit.dart';
import 'package:firstproject/modules/social_app/social_login/cubit/cubit.dart';
import 'package:firstproject/modules/social_app/social_login/social_login_screen.dart';
import 'package:firstproject/modules/social_app/social_register/cubit/cubit.dart';
import 'package:firstproject/shared/bloc_observer.dart';
import 'package:firstproject/shared/components/constants.dart';
import 'package:firstproject/shared/cubit/cubit.dart';
import 'package:firstproject/shared/cubit/states.dart';
import 'package:firstproject/shared/network/local/cache_helper.dart';
import 'package:firstproject/shared/network/remote/dio_helper.dart';
import 'package:firstproject/shared/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/shop_layout/cubit/cubit.dart';
import 'modules/shop_app/shop_login/cubit/cubit.dart';

void main() {

  BlocOverrides.runZoned(
    () async {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

      DioHelper.init();
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
      );
      await CacheHelper.init();
      var isDark = CacheHelper.getBooleanData(key: 'isDark') ?? false;

    //  token = CacheHelper.getStringData(key: 'token');
    //   print(token.toString());
      // var onBoarding = CacheHelper.getBooleanData(key: 'onBoarding');
      uId =CacheHelper.getStringData(key: 'uId');
      Widget? widget;
      if(uId != null)
        {
          widget = SocialLayout();
        }
      else
        {
          widget = SocialLoginScreen();
        }


      runApp(MyApp(isDark, NewsLayout()));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  late final bool isDark;
  late final Widget startWidget;

  MyApp(this.isDark, this.startWidget);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => NewsCubit()..getBusinessData()),
        BlocProvider(create: (BuildContext context) => ShopRegisterCubit()),
        BlocProvider(create: (BuildContext context) => SearchCubit()),
        BlocProvider(create: (BuildContext context) => ShopLoginCubit()),
        BlocProvider(
            create: (BuildContext context) =>
                AppCubit()..changeAppMode(fromShared: isDark)),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavoritesData()
            ..getUserData(),
        ),
        BlocProvider(create: (BuildContext context) => SocialRegisterCubit()),
        BlocProvider(create: (BuildContext context) => SocialLoginCubit()),
        BlocProvider(create: (BuildContext context) => SocialCubit()..getUserData()),

      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          return MaterialApp(


            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme: darkTheme,
            theme: lightTheme,
            debugShowCheckedModeBanner: false,
            home: startWidget,
          );
        },
      ),
    );
  }
}
