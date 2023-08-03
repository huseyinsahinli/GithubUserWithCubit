import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc/core/api/api_constanst.dart';
import 'package:learn_bloc/models/user_model.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit() : super(UserInitial());

  final Dio dio = Dio();

  TextEditingController userNameController = TextEditingController();
  String getUserName() => userNameController.text.trim();

  Future<void> getUserData() async {
    try {
      emit(UserLoading());
      final response = await dio.get(
        APIConstants.user.replaceFirst(
          "{username}",
          getUserName(),
        ),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${APIConstants.githubToken}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final userData = User.fromJson(response.data);
        emit(UserLoaded(userData));
      } else {
        emit(UserError("Error -> ${response.statusCode}"));
      }
    } catch (e) {
      emit(UserError("Error -> $e"));
    }
  }

  void clearUserData() {
    emit(UserInitial());
  }
}
