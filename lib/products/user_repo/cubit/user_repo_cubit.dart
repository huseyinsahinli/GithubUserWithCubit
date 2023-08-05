import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc/core/api/api_constanst.dart';
import 'package:learn_bloc/models/user_repo_model.dart';

part 'user_repo_state.dart';

class UserRepoCubit extends Cubit<UserRepoState> {
  final String userName;
  final List<RepoModel> repos = [];
  UserRepoCubit(this.userName) : super(UserRepoInitial()) {
    getUserRepos();
  }
  TextEditingController searchController = TextEditingController();
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
        final userRepoData = (response.data as List).map((e) => RepoModel.fromJson(e as Map<String, dynamic>)).toList();
        repos.addAll(userRepoData);
        emit(UserRepoLoaded(userRepoData));
      } else {
        emit(UserRepoError("Error -> ${response.statusCode}"));
      }
    } catch (e) {
      emit(UserRepoError("Error -> $e"));
    }
  }

  void searchRepo(String query) {
    List<RepoModel> searchRepos = [];
    if (query.isEmpty) {
      emit(UserRepoLoaded(repos));
    } else {
      searchRepos = repos.where((element) => (element.name?.toLowerCase() ?? "").contains(query.toLowerCase())).toList();
      emit(UserRepoLoaded(searchRepos));
    }
  }
}
