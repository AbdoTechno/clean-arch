import 'package:clean_arch/core/errors/failure.dart';
import 'package:clean_arch/features/user/domain/entities/user_entity.dart';
import 'package:clean_arch/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetUser {
  final UserRepository repository;
  GetUser(this.repository);
  Future<Either<Failure, UserEntity>> call(){
    return repository.getUser();
  }
}