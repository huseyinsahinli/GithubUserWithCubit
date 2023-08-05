part of 'user_followers_cubit_cubit.dart';

abstract class UserFollowersState extends Equatable {
  const UserFollowersState();

  @override
  List<Object> get props => [];
}

class UserFollowersCubitInitial extends UserFollowersState {}

class UserFollowersLoaded extends UserFollowersState {
  final List<UserFollowModel> userFollowers;

  const UserFollowersLoaded(this.userFollowers);

  @override
  List<Object> get props => [userFollowers];
}

class UserFollowersLoading extends UserFollowersState {
  @override
  List<Object> get props => [];
}

class UserFollowersError extends UserFollowersState {
  final String message;

  const UserFollowersError(this.message);

  @override
  List<Object> get props => [message];
}
