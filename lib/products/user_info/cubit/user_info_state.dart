part of 'user_info_cubit.dart';

abstract class UserInfoState extends Equatable {
  const UserInfoState();
}

class UserInitial extends UserInfoState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserInfoState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserLoading extends UserInfoState {
  @override
  List<Object> get props => [];
}

class UserError extends UserInfoState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}
