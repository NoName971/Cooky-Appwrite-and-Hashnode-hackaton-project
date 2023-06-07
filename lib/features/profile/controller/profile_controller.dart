import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/ui_messages.dart';
import 'package:hackaton_v1/core/utils.dart';
import 'package:hackaton_v1/features/auth/views/login_view.dart';
import 'package:hackaton_v1/services/auth_service.dart';

final profileProvider = StateNotifierProvider<ProfileController, bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ProfileController(authService: authService);
});

class ProfileController extends StateNotifier<bool> {
  final AuthService _authService;
  ProfileController({
    required AuthService authService,
  })  : _authService = authService,
        super(false);

  Future<void> logout({
    required BuildContext context,
  }) async {
    state = !state;
    final response = await _authService.logout();
    state = !state;
    if (response.failure != null) {
      if (context.mounted) {
        showSnackBar(
          context,
          response.failure?.message ?? UiMessages.unexpectedError,
        );
      }
    } else {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          LoginView.route(),
          (route) => false,
        );
        showSnackBar(context, 'Logged out');
      }
    }
  }

  Future<void> updatePassword({
    required BuildContext context,
    required String password,
    required String oldPassword,
  }) async {
    state = !state;
    final response = await _authService.updatePassword(
      password: password,
      oldPassword: oldPassword,
    );
    state = !state;
    if (response.failure != null) {
      if (context.mounted) {
        showSnackBar(
          context,
          response.failure?.message ?? UiMessages.unexpectedError,
        );
      }
    } else {
      if (context.mounted) {
        Navigator.pop(
          context,
        );
        showSnackBar(context, 'Password updated');
      }
    }
  }
}
