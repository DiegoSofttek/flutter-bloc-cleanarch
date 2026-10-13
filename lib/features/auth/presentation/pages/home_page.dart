// Minimal post-login landing page. Shows how a screen reads the logged-in
// user from AuthCubit and triggers logout — intentionally kept data-free so
// it does not require its own domain layer.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Minimal landing page shown after a successful login.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: AppStrings.logout,
            onPressed: () {
              context.read<AuthCubit>().logout();
              context.go(RouteNames.login);
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state is AuthSuccess ? state.user : null;
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  user != null
                      ? 'Welcome, ${user.name}!'
                      : AppStrings.appName,
                  style: AppTextStyles.headline2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
