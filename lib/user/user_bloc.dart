import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

import 'user_event.dart';
import 'user_state.dart';
import '../../models/user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  static const int limit = 10;
  int skip = 0;
  bool isFetching = false;
  String currentSearch = '';

  Timer? _debounce;

  UserBloc() : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SearchUsers>(_onSearchUsers, transformer: _debounceTransformer());
  }

  EventTransformer<SearchUsers> _debounceTransformer<SearchUsers>() {
    return (events, mapper) {
      return events.debounceTime(Duration(milliseconds: 300)).switchMap(mapper);
    };
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    if (isFetching) return;
    isFetching = true;

    try {
      if (event.isInitialFetch) {
        skip = 0;
        emit(UserLoading());
      }

      final url = currentSearch.isEmpty
          ? 'https://dummyjson.com/users?limit=$limit&skip=$skip'
          : 'https://dummyjson.com/users/search?q=$currentSearch&limit=$limit&skip=$skip';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> usersJson = data['users'];
        final users = usersJson.map((e) => User.fromJson(e)).toList();

        final currentState = state;

        List<User> allUsers = [];
        if (currentState is UserLoaded && !event.isInitialFetch) {
          allUsers = List.from(currentState.users)..addAll(users);
        } else {
          allUsers = users;
        }

        bool hasReachedMax = users.length < limit;

        skip += limit;

        emit(UserLoaded(users: allUsers, hasReachedMax: hasReachedMax));
      } else {
        emit(UserError('Failed to fetch users'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    } finally {
      isFetching = false;
    }
  }

  Future<void> _onSearchUsers(SearchUsers event, Emitter<UserState> emit) async {
    currentSearch = event.query.trim();
    skip = 0;
    add(FetchUsers(isInitialFetch: true));
  }
}
