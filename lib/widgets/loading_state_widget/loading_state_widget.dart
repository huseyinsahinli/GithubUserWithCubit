import 'package:flutter/material.dart';
import 'package:learn_bloc/core/custom/colors.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
        ),
        const Center(
          child: CircularProgressIndicator(
            color: CustomColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
