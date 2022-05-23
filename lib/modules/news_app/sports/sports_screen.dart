import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:firstproject/layout/news_layout/cubit/cubit.dart';
import 'package:firstproject/layout/news_layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../shared/components/components.dart';


class SportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, states) {
        var list = NewsCubit.get(context).sports;

        return articleBuilder(list);
      },
    );
  }
}
