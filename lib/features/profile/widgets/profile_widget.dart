import 'package:flutter/material.dart';
import 'package:hackaton_v1/common/text_style.dart';
import 'package:hackaton_v1/helpers/extensions.dart';
import 'package:hackaton_v1/models/user_model.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.currentUser,
  });

  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 16, bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorScheme.primary,
          ),
          child: Center(
            child: FittedBox(
              child: Text(
                getInitials(currentUser.name),
                style: context.h2.copyWith(
                  color: context.colorScheme.background,
                ),
              ),
            ),
          ),
        ),
        Text(
          currentUser.name,
          style: context.h4,
        ),
        Text(
          currentUser.email,
        )
      ],
    );
  }
}
