
import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPosts extends PostEvent {
  final int userId;
  final int limit;
  final int skip;

  FetchPosts(this.userId, {this.limit = 10, this.skip = 0});
}

class AddPost extends PostEvent {
  final String title;
  final String body;
  final int userId;

  AddPost(this.title, this.body, this.userId);
}
