part of 'user_repo_cubit.dart';

abstract class UserRepoState extends Equatable {
  const UserRepoState();
}

class UserRepoInitial extends UserRepoState {
  @override
  List<Object> get props => [];
}

class UserRepoLoaded extends UserRepoState {
  final List<RepoModel> repos;

  const UserRepoLoaded(this.repos);

  @override
  List<Object> get props => [repos];
}

class UserRepoLoading extends UserRepoState {
  @override
  List<Object> get props => [];
}

class UserRepoError extends UserRepoState {
  final String message;

  const UserRepoError(this.message);

  @override
  List<Object> get props => [message];
}
