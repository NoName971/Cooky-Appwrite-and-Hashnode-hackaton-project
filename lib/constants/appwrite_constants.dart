class AppwriteConstants {
  static const String projectId = '645f8ebc6bc0907f7922';
  static const String apiEndpoint = 'https://cloud.appwrite.io/v1';
  static const String usersCollectionId = '646885e20505c74a8553';
  static const String marketplaceDatabaseId = '646288d51d22ac486c62';
  static const String recipeCollectionId = '6462890c9dca58ce3a71';
  static const String recipesBucketId = '64708527e725896898cb';
  static const String favoritesCollectionId = '6478c3b8da73d1ee07dd';
  static const String likesCollectionId = '647482f66af15c81e658';

  static imageUrl(String imageId) =>
      '$apiEndpoint/storage/buckets/$recipesBucketId/files/$imageId/view?project=$projectId';
}
