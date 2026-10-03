import 'package:clean_arch/core/databases/api/api_consumer.dart';
import 'package:clean_arch/core/databases/api/end_points.dart';
import 'package:clean_arch/core/params/user_params.dart';
import 'package:clean_arch/features/user/data/models/user_model.dart';

class UserRemoteDataSource {
  final ApiConsumer apiConsumer;
  UserRemoteDataSource(this.apiConsumer);
  Future<UserModel> getUser(UserParams? params) async {
    final response = await apiConsumer.get(
      "${EndPoints.users}/${params?.userId}",
    );
    return UserModel.fromJson(response);
  }
}
