import 'package:flutter/material.dart';
import 'package:learn_bloc/core/custom/colors.dart';

class LoadingState extends StatelessWidget {
  final double height;
  const LoadingState({super.key, this.height = 0.4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * height,
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
