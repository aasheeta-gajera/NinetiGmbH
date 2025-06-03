import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ninetigmbh/screens/user_list_screen.dart';

import 'blocs/user_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User BLoC App',
      home: BlocProvider(
        create: (_) => UserBloc(),
        child: UserListScreen(),
      ),
    );
  }
}
