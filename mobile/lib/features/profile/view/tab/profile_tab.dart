import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hydronex_app/core/network/api_client.dart';
import 'package:hydronex_app/core/storage/token_storage.dart';
import 'package:hydronex_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:hydronex_app/core/routes/app_routes.dart';
import 'package:hydronex_app/core/routes/route_context_extention.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/core/widgets/custom_dropdown.dart';
import 'package:hydronex_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:hydronex_app/features/profile/view/screens/help_support_screen.dart';
import 'package:hydronex_app/features/profile/view/widgets/profile_header.dart';
import 'package:hydronex_app/features/profile/view/widgets/profile_navigation_item.dart';
import 'package:hydronex_app/features/profile/view_model/profile_view_model.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late ProfileViewModel viewModel;

  @override
  void initState() {
    super.initState();

    final Dio dio = ApiClient.create(tokenStorage: const TokenStorage());

    final ProfileRemoteDataSource remoteDataSource = ProfileRemoteDataSource(
      dio: dio,
    );

    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    viewModel = ProfileViewModel(
      repository: repository,
      tokenStorage: const TokenStorage(),
    );

    viewModel.loadProfile();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        if (viewModel.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }

        if (viewModel.errorMessage != null) {
          return Center(child: Text(viewModel.errorMessage!));
        }

        if (viewModel.profile == null) {
          return SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(profile: viewModel.profile!),
              SizedBox(height: 30),
              CustomDropdown(
                hintText: 'Appearance',
                items: ['Light'],
                leadingIconName: 'appearance',
                borderColor: AppTheme.primary.withValues(alpha: 0.14),
              ),
              SizedBox(height: 8),
              ProfileNavigationItem(
                title: 'Account Settings',
                iconName: 'settings',
                onTap: () {},
              ),
              const SizedBox(height: 8),
              ProfileNavigationItem(
                title: 'Help & Support',
                iconName: 'help',
                onTap: () {
                  context.pushNamed(AppRoutes.helpSupport);
                },
              ),
              SizedBox(height: 8),
              ProfileNavigationItem(
                title: 'Logout',
                iconName: 'logout',
                textColor: AppTheme.criticalText,
                onTap: () async {
                  await viewModel.logout();
                  if (!context.mounted) return;
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
