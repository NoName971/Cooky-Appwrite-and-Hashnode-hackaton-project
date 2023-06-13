import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/ui_messages.dart';
import 'package:hackaton_v1/helpers/utils.dart';
import 'package:hackaton_v1/features/auth/views/login_view.dart';
import 'package:hackaton_v1/main.dart';
import 'package:hackaton_v1/services/auth_service.dart';
import 'package:hackaton_v1/services/user_service.dart';

final profileProvider = StateNotifierProvider<ProfileController, bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  final userService = ref.watch(userServiceProvider);
  return ProfileController(
    authService: authService,
    userService: userService,
  );
});

class ProfileController extends StateNotifier<bool> {
  final AuthService _authService;
  final UserService _userService;
  ProfileController({
    required AuthService authService,
    required UserService userService,
  })  : _authService = authService,
        _userService = userService,
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

  Future<void> updateFullName({
    required String name,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      state = !state;
      final currentUser = await _authService.getCurrentUser();
      final response = await _authService.updateFullName(name: name);
      if (response.hasSucceded) {
        final response2 = await _userService.updateUserData(
          data: {
            'name': name,
          },
          uid: currentUser!.$id,
        );
        state = !state;
        if (response2.hasSucceded) {
          ref.read(globalCurrentUserProvider.notifier).update(
                (state) => state.copyWith(name: name),
              );

          if (context.mounted) {
            showSnackBar(context, 'Updated');
            Navigator.pop(context);
          }
        } else {
          if (context.mounted) {
            showSnackBar(context, response.failure.toString());
          }
        }
      } else {
        state = !state;

        if (context.mounted) {
          showSnackBar(context, response.failure!.message);
        }
      }
    } catch (e, st) {
      state = !false;

      logger.d(st);
      showSnackBar(context, e.toString());
    }
  }
}
