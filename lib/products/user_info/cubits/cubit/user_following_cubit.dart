import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc/core/api/api_constanst.dart';
import 'package:learn_bloc/models/user_followers.dart';

part 'user_following_state.dart';

class UserFollowingCubit extends Cubit<UserFollowingState> {
  final String userName;

  UserFollowingCubit(
    this.userName,
  ) : super(UserFollowingInitial()) {
    getUserFollowers();
  }

  final Dio dio = Dio();

  Future<void> getUserFollowers({String? user}) async {
    try {
      emit(UserFollowingLoading());
      await Future.delayed(const Duration(seconds: 2));
      final response = await dio.get(
        APIConstants.userFollowing.replaceFirst(
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
        List<UserFollowModel> userFollowers = [];
        response.data.forEach((element) {
          userFollowers.add(UserFollowModel.fromJson(element));
        });
        emit(UserFollowingLoaded(userFollowers));
      } else {
        emit(UserFollowingError("Error -> ${response.statusCode}"));
      }
    } catch (e) {
      emit(UserFollowingError("Error -> $e"));
    }
  }
}
