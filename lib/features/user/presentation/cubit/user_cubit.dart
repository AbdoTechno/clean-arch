import 'package:bloc/bloc.dart';
import 'package:clean_arch/core/connection/network_info.dart';
import 'package:clean_arch/core/databases/api/dio_consumer.dart';
import 'package:clean_arch/core/databases/cache/cache_helper.dart';
import 'package:clean_arch/core/errors/failure.dart';
import 'package:clean_arch/core/params/user_params.dart';
import 'package:clean_arch/features/user/data/datasources/user_local_data_source.dart';
import 'package:clean_arch/features/user/data/datasources/user_remote_data_source.dart';
import 'package:clean_arch/features/user/data/repositories/user_repository_impl.dart';
import 'package:clean_arch/features/user/domain/entities/user_entity.dart';
import 'package:clean_arch/features/user/domain/usecases/get_user.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  eitherFailureOrUser(int userId) async {
    emit(UserLoading());
    final failureOrUser = await GetUser(
      repository: UserRepositoryImpl(
        networkInfo: NetworkInfoImpl(
          dataConnectionChecker: DataConnectionChecker(),
        ),
        remoteDataSource: UserRemoteDataSource(apiConsumer: DioConsumer()),
        localDataSource: UserLocalDataSource(cacheHelper: CacheHelper()),
      ),
    ).call(params: UserParams(userId: userId.toString()));
    failureOrUser.fold(
      (failure) => emit(UserError(failure: failure)),
      (user) => emit(UserLoaded(userEntity: user)),
    );
  }
}
