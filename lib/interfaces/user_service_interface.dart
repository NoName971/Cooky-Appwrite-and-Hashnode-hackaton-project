import '../models/failure.dart';
import '../models/user_model.dart';
import 'package:appwrite/models.dart' as model;

abstract class IUserService {
  Future<({Failure? failure, model.Document? userData})> saveUserData({
    required UserModel userModel,
  });

  Future<({Failure? failure, List? favorites})> addFavorite({
    required String recipeId,
  });
  Future<({Failure? failure, List? favorites})> removeFavorite({
    required String recipeId,
  });
  Future<List> getFavorites();
}
