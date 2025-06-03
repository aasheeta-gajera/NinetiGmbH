import 'package:ninetigmbh/models/user_model.dart';
import 'package:ninetigmbh/repositories/user_repository.dart';
import 'package:ninetigmbh/datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource = UserRemoteDataSource();

  @override
  Future<List<UserModel>> getUsers({int limit = 10, int skip = 0}) {
    return remoteDataSource.fetchUsers(limit: limit, skip: skip);
  }
}
