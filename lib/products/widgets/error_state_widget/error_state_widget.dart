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
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  color: CustomColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
