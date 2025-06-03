import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user_bloc.dart';
import '../blocs/user_event.dart';
import '../blocs/user_state.dart';

class UserListScreen extends StatefulWidget {
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUsers());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          !(context.read<UserBloc>().state as UserLoaded).hasReachedMax) {
        context.read<UserBloc>().add(LoadMoreUsers());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) return Center(child: CircularProgressIndicator());

          if (state is UserLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.image),
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                );
              },
            );
          }

          if (state is UserError) return Center(child: Text(state.message));

          return Container();
        },
      ),
    );
  }
}
