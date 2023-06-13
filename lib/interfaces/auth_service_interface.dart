import 'package:hackaton_v1/models/failure.dart';

import 'package:appwrite/models.dart' as model;

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
}
