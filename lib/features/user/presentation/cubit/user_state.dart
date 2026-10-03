part of 'user_cubit.dart';

@immutable
abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final UserEntity userEntity;
  const UserLoaded({required this.userEntity});
  @override
  List<Object> get props => [userEntity];
}

class UserError extends UserState {
  final Failure failure;
  const UserError({required this.failure});
  @override
  List<Object> get props => [failure];
}
