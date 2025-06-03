import 'package:ninetigmbh/models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers({int limit, int skip});
}
