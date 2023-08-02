import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_bloc/core/api/api_constanst.dart';
import 'package:learn_bloc/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final Dio dio = Dio();

  TextEditingController userNameController = TextEditingController();

  Future<void> getUserData() async {
    final userName = userNameController.text.trim();

    try {
      emit(UserLoading());
      await Future.delayed(const Duration(seconds: 1));
      final response = await Dio().get(
        APIConstants.user.replaceFirst(
          "{username}",
          userName,
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
