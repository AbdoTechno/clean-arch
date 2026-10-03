import 'dart:convert';

import 'package:clean_arch/core/databases/cache/cache_helper.dart';
import 'package:clean_arch/core/errors/exceptions.dart';
import 'package:clean_arch/features/user/data/models/user_model.dart';

class UserLocalDataSource {
  void cacheUser(UserModel? user) {
    if (user != null) {
      CacheHelper().setString(key: "user", value: json.encode(user.toJson()));
    } else {
      throw CacheException(errorMessage: "No Internet Connection");
    }
  }

  Future<UserModel> getLastUser() async {
    final jsonString = CacheHelper().getString(key: "user");
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    } else {
      throw CacheException(errorMessage: "No cached user found");
    }
  }
}
