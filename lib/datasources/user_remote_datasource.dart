// lib/datasources/user_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:ninetigmbh/models/user_model.dart';

class UserRemoteDataSource {
  Future<List<UserModel>> fetchUsers({int limit = 10, int skip = 0}) async {
    final response = await Dio().get(
      'https://dummyjson.com/users',
      queryParameters: {
        'limit': limit,
        'skip': skip,
      },
    );

    final List<dynamic> usersJson = response.data['users'];
    return usersJson.map((json) => UserModel.fromJson(json)).toList();
  }
}
