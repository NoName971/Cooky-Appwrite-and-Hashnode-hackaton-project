import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/ui_messages.dart';
import 'package:hackaton_v1/helpers/utils.dart';
import 'package:hackaton_v1/features/home/views/home_view.dart';
import 'package:hackaton_v1/main.dart';
import 'package:hackaton_v1/models/user_model.dart';
import 'package:hackaton_v1/services/auth_service.dart';
import 'package:appwrite/models.dart' as model;
import 'package:hackaton_v1/services/user_service.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  final userService = ref.watch(userServiceProvider);

  return AuthController(
    authService: authService,
    userService: userService,
    ref: ref,
  );
});

final currentAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  final currentUser = await authController.getCurrentUser();
  ref.read(globalCurrentUserProvider.notifier).update(
        (state) => state.copyWith(
          email: currentUser!.email,
          name: currentUser.name,
          uid: currentUser.$id,
          isVerified: currentUser.emailVerification,
        ),
      );
  return currentUser;
});

class AuthController extends StateNotifier<bool> {
  final AuthService _authService;
  final UserService _userService;
  final Ref _ref;
  AuthController({
    required AuthService authService,
    required UserService userService,
    required Ref ref,
  })  : _authService = authService,
        _userService = userService,
        _ref = ref,
        super(false);

  void register({
    required String email,
    required String password,
    required BuildContext context,
    String? fullName,
  }) async {
    state = true;
    final (response) = await _authService.register(
      email: email,
      password: password,
      name: fullName ?? getNameFromEmail(email),
    );
    if (response.user != null) {
      final userModel = UserModel(
        email: email,
        name: fullName ?? getNameFromEmail(email),
        uid: response.user!.$id,
      );
      final userData = await _userService.saveUserData(userModel: userModel);
      state = false;
      if (userData.userData != null) {
        if (context.mounted) {
          showSnackBar(context, UiMessages.registered);
          Navigator.pop(context);
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, response.failure!.message);
        }
      }
    } else {
      state = false;
      if (context.mounted) {
        showSnackBar(context, response.failure!.message);
      }
    }
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = !state;
    final response = await _authService.login(
      email: email,
      password: password,
    );
    state = !state;
    if (response.hasSucceded) {
      final currentUser = await getCurrentUser();
      _ref.read(globalCurrentUserProvider.notifier).update(
            (state) => state.copyWith(
              email: currentUser!.email,
              name: currentUser.name,
              uid: currentUser.$id,
            ),
          );
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          HomeView.route(),
          (route) => false,
        );
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, response.failure!.message);
      }
    }
  }

  void sendPasswordRecoveryEmail({
    required String email,
    required BuildContext context,
  }) async {
    state = !state;
    final response = await _authService.sendPasswordRecoveryEmail(
      email: email,
    );
    state = !state;
    if (response.hasSucceded) {
      if (context.mounted) {
        Navigator.pop(context);
        showSnackBar(
          context,
          'Password recovery email sent',
          const Duration(seconds: 10),
        );
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, response.failure!.message);
      }
    }
  }

  Future<model.User?> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }
}
