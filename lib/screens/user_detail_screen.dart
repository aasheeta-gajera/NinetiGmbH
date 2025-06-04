import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';
import '../post/post_bloc.dart';
import '../post/post_event.dart';
import '../post/post_state.dart';
import '../todo/todo_bloc.dart';
import '../todo/todo_event.dart';
import '../todo/todo_state.dart';
import '../widgets/post_tile.dart';
import '../widgets/todo_tile.dart';
import 'create_post_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;

  const UserDetailScreen({required this.user, Key? key}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late int skip;
  final int limit = 5;

  @override
  void initState() {
    super.initState();
    skip = 0;
    final postBloc = context.read<PostBloc>();
    final todoBloc = context.read<TodoBloc>();

    postBloc.add(FetchPosts(widget.user.id));
    todoBloc.add(FetchTodos(widget.user.id));
  }

  Future<void> _refreshAll() async {
    final postBloc = context.read<PostBloc>();
    final todoBloc = context.read<TodoBloc>();

    postBloc.add(FetchPosts(widget.user.id));
    todoBloc.add(FetchTodos(widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.firstName} ${widget.user.lastName}'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAll,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(widget.user.image),
                  ),
                  title: Text(
                    '${widget.user.firstName} ${widget.user.lastName}',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(widget.user.email,
                      style: theme.textTheme.bodyMedium),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posts',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreatePostScreen(),
                        ),
                      );
                      if (result != null && result is Map<String, String>) {
                        context.read<PostBloc>().add(
                          AddPost(
                            result['title']!,
                            result['body']!,
                            widget.user.id,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Post'),
                    style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PostLoaded) {
                    if (state.posts.isEmpty) {
                      return Text('No posts found.', style: theme.textTheme.bodyMedium);
                    }

                    return Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.posts.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) =>
                              PostTile(post: state.posts[index]),
                        ),
                        const SizedBox(height: 12),
                        if (state.posts.length >= limit)
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                skip += limit;
                                context.read<PostBloc>().add(
                                    FetchPosts(widget.user.id,
                                        limit: limit, skip: skip));
                              },
                              child: const Text('Load More'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                            ),
                          )
                      ],
                    );
                  } else if (state is PostError) {
                    return Text(state.message,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.colorScheme.error));
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),
              Text('Todos',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  if (state is TodoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TodoLoaded) {
                    if (state.todos.isEmpty) {
                      return Text('No todos found.', style: theme.textTheme.bodyMedium);
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.todos.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) => TodoTile(todo: state.todos[index]),
                    );
                  } else if (state is TodoError) {
                    return Text(state.message,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.colorScheme.error));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
