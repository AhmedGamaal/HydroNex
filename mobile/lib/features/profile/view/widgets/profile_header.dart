import 'package:flutter/material.dart';
import 'package:hydronex_app/features/profile/data/models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  ProfileModel profile;

  ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          const SizedBox(height: 8),
          Text(profile.name, style: textTheme.titleMedium),
          Text(profile.email, style: textTheme.labelLarge),
        ],
      ),
    );
  }
}
