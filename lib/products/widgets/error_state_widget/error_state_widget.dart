import 'package:flutter/material.dart';
import 'package:learn_bloc/core/custom/colors.dart';

class ErrorState extends StatelessWidget {
  final String message;

  const ErrorState({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: CustomColors.primaryColor,
        ),
      ),
    );
  }
}
