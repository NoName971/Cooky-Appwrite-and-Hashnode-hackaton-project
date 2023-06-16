import 'package:hackaton_v1/models/failure.dart';

import 'package:appwrite/models.dart' as model;

import '../helpers/typedefs.dart';

abstract class IAuthService {
  Future<({Failure? failure, model.User? user})> register({
    required String email,
    required String password,
    required String name,
  });

  Future<model.User?> getCurrentUser();

  Future<({Failure? failure, bool? hasSucceded})> logout();

  Future<({Failure? failure, bool? hasSucceded})> updatePassword({
    required String password,
    required String oldPassword,
  });

  Future<({Failure? failure, bool hasSucceded})> login({
    required String email,
    required String password,
  });

  FutureOr updateFullName({
    required String name,
  });
  FutureOr sendPasswordRecoveryEmail({
    required String email,
  });
  FutureOr sendAccountVerificationEmail({
    required String email,
  });
}
