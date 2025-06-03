
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ninetigmbh/repositories/user_repository_impl.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepositoryImpl _repo = UserRepositoryImpl();
  int skip = 0;
  final int limit = 10;

  UserBloc() : super(UserInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await _repo.getUsers(limit: limit, skip: 0);
        skip = limit;
        emit(UserLoaded(users, hasReachedMax: false));
      } catch (e) {
        emit(UserError("Error loading users"));
      }
    });

    on<LoadMoreUsers>((event, emit) async {
      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        try {
          final users = await _repo.getUsers(limit: limit, skip: skip);
          if (users.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            skip += limit;
            emit(UserLoaded([...currentState.users, ...users], hasReachedMax: false));
          }
        } catch (_) {
          emit(UserError("Failed to load more users"));
        }
      }
    });
  }
}
