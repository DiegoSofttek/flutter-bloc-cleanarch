// Login screen: wires AppTextField/AppButton/AppErrorWidget to AuthCubit.
// Serves as the canonical example of a full feature's presentation layer.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Login screen: collects credentials and delegates to [AuthCubit].
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go(RouteNames.home);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.loginGradient,
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 80,
                          color: AppColors.surface,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppStrings.appName,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headline1.copyWith(
                            color: AppColors.surface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.loginSubtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyText.copyWith(
                            color: AppColors.surface.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 40),
                        AppTextField(
                          controller: _emailController,
                          label: AppStrings.emailLabel,
                          hint: AppStrings.emailHint,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.emailRequired;
                            }
                            if (!value.contains('@')) {
                              return AppStrings.emailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _passwordController,
                          label: AppStrings.passwordLabel,
                          hint: AppStrings.passwordHint,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.passwordRequired;
                            }
                            if (value.length < 6) {
                              return AppStrings.passwordTooShort;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return AppButton(
                              label: AppStrings.loginButton,
                              isLoading: isLoading,
                              onPressed: isLoading ? null : _onLoginPressed,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is AuthFailure) {
                              return AppErrorWidget(
                                message: state.message,
                                onRetry: null,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
