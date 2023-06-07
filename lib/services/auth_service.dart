import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/ui_messages.dart';
import 'package:hackaton_v1/core/providers.dart';
import 'package:hackaton_v1/models/failure.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;

import '../interfaces/auth_service_interface.dart';

final authServiceProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthService(account: account);
});

class AuthService implements IAuthService {
  final Account _account;
  AuthService({required Account account}) : _account = account;

  @override
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

  @override
  Future<({Failure? failure, model.Session? session})> login({
    required String email,
    required String password,
  }) async {
    try {
      final model.Session session = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return (
        failure: null,
        session: session,
      );
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? 'Something went wrong', stackTrace),
        session: null
      );
    } catch (e, stackTrace) {
      return (
        failure: Failure(e.toString(), stackTrace),
        session: null,
      );
    }
  }

  @override
  Future<model.User?> currentUser() async {
    return await _account.get();
  }

  @override
  Future<({Failure? failure, bool? isSucceded})> logout() async {
    try {
      final session = await _account.getSession(sessionId: 'current');
      await _account.deleteSession(sessionId: session.$id);
      return (failure: null, isSucceded: true);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? 'Something went wrong', stackTrace),
        isSucceded: null
      );
    } catch (e, stackTrace) {
      return (
        failure: Failure(e.toString(), stackTrace),
        isSucceded: null,
      );
    }
  }

  @override
  Future<({Failure? failure, bool? isSucceded})> updatePassword({
    required String password,
    required String oldPassword,
  }) async {
    try {
      await _account.updatePassword(
          password: password, oldPassword: oldPassword);
      return (failure: null, isSucceded: true);
    } on AppwriteException catch (e, stackTrace) {
      return (
        failure: Failure(e.message ?? 'Something went wrong', stackTrace),
        isSucceded: null
      );
    } catch (e, stackTrace) {
      return (
        failure: Failure(e.toString(), stackTrace),
        isSucceded: null,
      );
    }
  }
}
