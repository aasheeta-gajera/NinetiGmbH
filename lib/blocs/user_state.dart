

import '../models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;
  final bool hasReachedMax;

  UserLoaded(this.users, {this.hasReachedMax = false});

  UserLoaded copyWith({
    List<UserModel>? users,
    bool? hasReachedMax,
  }) {
    return UserLoaded(
      users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
