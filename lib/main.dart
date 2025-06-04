import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ninetigmbh/theme/Colors..dart';
import 'package:ninetigmbh/user/user_bloc.dart';
import 'package:ninetigmbh/post/post_bloc.dart';
import 'package:ninetigmbh/todo/todo_bloc.dart';
import 'package:ninetigmbh/screens/user_list_screen.dart';
import 'package:ninetigmbh/theme/theme_cubit.dart'; // import ThemeCubit

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (_) => UserBloc()),
        BlocProvider<PostBloc>(create: (_) => PostBloc()),
        BlocProvider<TodoBloc>(create: (_) => TodoBloc()),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()), // add this
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'DummyJSON Users',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            home: const UserListScreen(),
          );
        },
      ),
    );
  }
}
