import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';
import '../theme/theme_cubit.dart';
import '../user/user_bloc.dart';
import '../user/user_event.dart';
import '../user/user_state.dart';
import '../widgets/user_tile.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = context.read<UserBloc>();
    _userBloc.add(FetchUsers(isInitialFetch: true));

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _searchController = TextEditingController();
    _searchController.addListener(() {
      final query = _searchController.text.trim();
      _userBloc.add(SearchUsers(query));
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !_userBloc.isFetching) {
      final state = _userBloc.state;
      if (state is UserLoaded && !state.hasReachedMax) {
        _userBloc.add(FetchUsers());
      }
    }
  }

  Future<void> _refreshUsers() async {
    _userBloc.add(FetchUsers(isInitialFetch: true));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search users by name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.1),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserLoaded) {
                  if (state.users.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }
                  return RefreshIndicator(
                    onRefresh: _refreshUsers,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.hasReachedMax
                          ? state.users.length
                          : state.users.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.users.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final user = state.users[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: UserTile(
                              user: user,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserDetailScreen(user: user),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is UserError) {
                  return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: theme.colorScheme.error),
                      ));
                } else {
                  return const Center(child: Text('Please wait...'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
