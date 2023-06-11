import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/ui_messages.dart';
import 'package:hackaton_v1/constants/appwrite_providers.dart';
import 'package:hackaton_v1/models/failure.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;

final authServiceProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthService(account: account);
});

class AuthService {
  final Account _account;
  AuthService({required Account account}) : _account = account;

  Future<({Failure? failure, model.User? user})> register({
    required String email,
    required String password,
  }) async {
    try {
      final model.User user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return (
        failure: null,
        user: user,
      );
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? UiMessages.unexpectedError, stackTrace),
        user: null
      );
    } catch (e, stackTrace) {
      return (
        failure: Failure(e.toString(), stackTrace),
        user: null,
      );
    }
  }

  Future<({Failure? failure, bool hasSucceded})> login({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailSession(
        email: email,
        password: password,
      );
      return (
        failure: null,
        hasSucceded: true,
      );
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? 'Something went wrong', stackTrace),
        hasSucceded: false
      );
    } catch (e, stackTrace) {
      return (
        failure: Failure(e.toString(), stackTrace),
        hasSucceded: false,
      );
    }
  }

  Future<model.User?> currentUser() async {
    return await _account.get();
  }

  Future<({Failure? failure, bool? hasSucceded})> logout() async {
    try {
      final session = await _account.getSession(sessionId: 'current');
      await _account.deleteSession(sessionId: session.$id);
      return (failure: null, hasSucceded: true);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? 'Something went wrong', stackTrace),
        hasSucceded: false
      );
    } catch (e, stackTrace) {
      return (
        failure: Failure(e.toString(), stackTrace),
        hasSucceded: false,
      );
    }
  }

  Future<({Failure? failure, bool? hasSucceded})> updatePassword({
    required String password,
    required String oldPassword,
  }) async {
    try {
      await _account.updatePassword(
          password: password, oldPassword: oldPassword);
      return (failure: null, hasSucceded: true);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? 'Something went wrong', stackTrace),
        hasSucceded: false
      );
    } catch (e, stackTrace) {
      return (
        failure: Failure(e.toString(), stackTrace),
        hasSucceded: false,
      );
    }
  }
}
