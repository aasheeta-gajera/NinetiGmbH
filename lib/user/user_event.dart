import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {
  final bool isInitialFetch;

  FetchUsers({this.isInitialFetch = false});

  @override
  List<Object?> get props => [isInitialFetch];
}

class SearchUsers extends UserEvent {
  final String query;

  SearchUsers(this.query);

  @override
  List<Object?> get props => [query];
}
