import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'post_event.dart';
import 'post_state.dart';
import '../../models/post.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  List<Post> _posts = [];

  PostBloc() : super(PostInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<AddPost>(_onAddPost);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'user_${event.userId}_posts';
      final storedPosts = prefs.getStringList(key) ?? [];

      final allPosts = storedPosts.map((postJson) {
        final data = json.decode(postJson);
        return Post.fromJson(data);
      }).toList();

      final paginatedPosts = allPosts.skip(event.skip).take(event.limit).toList();

      emit(PostLoaded(paginatedPosts));
    } catch (e) {
      emit(PostError('Failed to load posts'));
    }
  }

  Future<void> _onAddPost(AddPost event, Emitter<PostState> emit) async {
    if (state is PostLoaded) {
      final currentState = state as PostLoaded;
      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch,
        title: event.title,
        body: event.body,
      );
      final updatedPosts = List<Post>.from(currentState.posts)..add(newPost);

      emit(PostLoaded(updatedPosts));

      final prefs = await SharedPreferences.getInstance();
      final key = 'user_${event.userId}_posts';
      final postJsonList = updatedPosts.map((post) => json.encode(post.toJson())).toList();
      await prefs.setStringList(key, postJsonList);
    }
  }
}
