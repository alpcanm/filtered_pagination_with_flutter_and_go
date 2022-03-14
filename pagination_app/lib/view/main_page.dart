library main_page;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_app/core/model/product_model.dart';

import '../core/tools/get_it_locator.dart';
import '../view_model/pagination_bloc.dart';
import 'components/_tag_list.dart';

part 'main_body.dart';
part 'components/filters.dart';
part 'components/more_button.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pagination App"),
        ),
        body: BlocProvider(
          create: (context) => PaginationBloc(),
          child: const _MainBody(),
        ));
  }
}
