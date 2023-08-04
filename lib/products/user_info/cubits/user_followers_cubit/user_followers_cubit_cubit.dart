import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc/core/api/api_constanst.dart';
import 'package:learn_bloc/models/user_followers.dart';

part 'user_followers_cubit_state.dart';

class UserFollowersCubit extends Cubit<UserFollowersState> {
  final String userName;

  UserFollowersCubit(this.userName) : super(UserFollowersCubitInitial()) {
    getUserFollowers();
  }
  final Dio dio = Dio();

  Future<void> getUserFollowers({String? user}) async {
    try {
      emit(UserFollowersLoading());
      await Future.delayed(const Duration(seconds: 2));
      final response = await dio.get(
        APIConstants.userFollowers.replaceFirst(
          "{username}",
          user ?? userName,
        ),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${APIConstants.githubToken}',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<UserFollowers> userFollowers = [];
        response.data.forEach((element) {
          userFollowers.add(UserFollowers.fromJson(element));
        });
        emit(UserFollowersLoaded(userFollowers));
      } else {
        emit(UserFollowersError("Error -> ${response.statusCode}"));
      }
    } catch (e) {
      emit(UserFollowersError("Error -> $e"));
    }
  }
}
