part of 'user_following_cubit.dart';

abstract class UserFollowingState extends Equatable {
  const UserFollowingState();

  @override
  List<Object> get props => [];
}

class UserFollowingInitial extends UserFollowingState {}

class UserFollowingLoaded extends UserFollowingState {
  final List<UserFollowModel> userFollowers;

  const UserFollowingLoaded(this.userFollowers);

  @override
  List<Object> get props => [userFollowers];
}

class UserFollowingLoading extends UserFollowingState {
  @override
  List<Object> get props => [];
}

class UserFollowingError extends UserFollowingState {
  final String message;

  const UserFollowingError(this.message);

  @override
  List<Object> get props => [message];
}
