import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:firstproject/layout/news_layout/cubit/cubit.dart';
import 'package:firstproject/layout/news_layout/cubit/states.dart';

import 'package:firstproject/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusinessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state) {},
      builder: (context, states) {
        var list =NewsCubit.get(context).business;
        return articleBuilder(list);
      },
    );
  }
}
