import 'package:hackaton_v1/models/failure.dart';

import 'package:appwrite/models.dart' as model;

abstract class IAuthService {
  Future<({Failure? failure, model.User? user})> register({
    required String email,
    required String password,
  });

  Future<({Failure? failure, model.Session? session})> login({
    required String email,
    required String password,
  });

  Future<model.User?> currentUser();
  Future<({Failure? failure, bool? isSucceded})> logout();
  Future<({Failure? failure, bool? isSucceded})> updatePassword({
    required String password,
    required String oldPassword,
  });
}
