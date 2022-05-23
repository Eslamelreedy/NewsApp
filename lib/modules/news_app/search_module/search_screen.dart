
import 'package:firstproject/layout/news_layout/cubit/cubit.dart';
import 'package:firstproject/layout/news_layout/cubit/states.dart';
import 'package:firstproject/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>NewsCubit(),
      child: BlocConsumer<NewsCubit,NewsStates>(
        builder: (BuildContext context, state) {
          var list = NewsCubit.get(context).search;

         return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      onChange: (value)
                      {
                       NewsCubit.get(context).getSearchData(value);
                      },
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'search must be not empty';
                        }
                        return null;
                      },
                      label: 'search',
                      prefix: Icons.search),
                ),
                Expanded(child: articleBuilder(list)),
              ],
            ),
          );
        },
        listener: (BuildContext context, Object? state) {  },

      ),
    );
  }
}
