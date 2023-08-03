import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc/core/api/api_constanst.dart';
import 'package:learn_bloc/models/user_repo_model.dart';

part 'user_repo_state.dart';

class UserRepoCubit extends Cubit<UserRepoState> {
  final String userName;

  UserRepoCubit(this.userName) : super(UserRepoInitial()) {
    getUserRepos();
  }
  Future<void> getUserRepos() async {
    final Dio dio = Dio();

    try {
      emit(UserRepoLoading());
      final response = await dio.get(
        APIConstants.userRepositories.replaceFirst(
          "{username}",
          userName,
        ),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${APIConstants.githubToken}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final userRepoData = (response.data as List).map((e) => Repo.fromJson(e as Map<String, dynamic>)).toList();
        emit(UserRepoLoaded(userRepoData));
      } else {
        emit(UserRepoError("Error -> ${response.statusCode}"));
      }
    } catch (e) {
      emit(UserRepoError("Error -> $e"));
    }
  }
}
