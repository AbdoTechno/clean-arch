import 'package:clean_arch/core/connection/network_info.dart';
import 'package:clean_arch/core/errors/exceptions.dart';
import 'package:clean_arch/core/errors/failure.dart';
import 'package:clean_arch/core/params/user_params.dart';
import 'package:clean_arch/features/user/data/datasources/user_local_data_source.dart';
import 'package:clean_arch/features/user/data/datasources/user_remote_data_source.dart';
import 'package:clean_arch/features/user/domain/entities/user_entity.dart';
import 'package:clean_arch/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl extends UserRepository {
  final NetworkInfo networkInfo;
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  UserRepositoryImpl(
    this.networkInfo,
    this.remoteDataSource,
    this.localDataSource,
  );
  @override
  Future<Either<Failure, UserEntity>> getUser({UserParams? params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteUser = await remoteDataSource.getUser(params);
        localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(
          Failure(errMessage: e.errorModel.errorMessage ?? "An error occurred"),
        );
      }
    } else {
      try {
        final localUser = await localDataSource.getLastUser();
        return Right(localUser);
      } on CacheException catch (e) {
        return Left(Failure(errMessage: e.errorMessage));
      }
    }
  }
}
