import 'package:flutter_dotenv/flutter_dotenv.dart';

final envProjectId = dotenv.env['PROJECT_ID'];
final envUsersCollectionId = dotenv.env['USERS_COLLECTION_ID'];
final envMainDatabaseId = dotenv.env['MAIN_DATABASE_ID'];
final envRecipeCollectionId = dotenv.env['RECIPES_COLLECTION_ID'];
final envRecipesBucketId = dotenv.env['RECIPES_BUCKET_ID'];
final envLikesCollectionId = dotenv.env['LIKES_COLLECTION_ID'];
final envEmailVerificationEndpoint = dotenv.env['EMAIL_VERIFICATION_ENDPOINT'];
final envPasswordRecoveryEndpoint = dotenv.env['PASSWORD_RECOVERY_ENDPOINT'];

class AppwriteConstants {
  static String? projectId = envProjectId;
  static const String apiEndpoint = 'https://cloud.appwrite.io/v1';
  static String usersCollectionId = envUsersCollectionId ?? '';
  static String mainDatabaseId = envMainDatabaseId ?? '';
  static String recipeCollectionId = envRecipeCollectionId ?? '';
  static String recipesBucketId = envRecipesBucketId ?? '';
  static String likesCollectionId = envLikesCollectionId ?? '';
  static String emailVerificationEndpoint = envEmailVerificationEndpoint ?? '';
  static String passwordRecoveryEndpoint = envPasswordRecoveryEndpoint ?? '';

  static imageUrl(String imageId) =>
      '$apiEndpoint/storage/buckets/$recipesBucketId/files/$imageId/view?project=$projectId';
}
