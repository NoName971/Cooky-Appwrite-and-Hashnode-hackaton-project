import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackaton_v1/constants/appwrite_constants.dart';
import 'package:hackaton_v1/constants/appwrite_providers.dart';
import 'package:hackaton_v1/helpers/utils.dart';
import 'package:uuid/uuid.dart';

import '../interfaces/storage_service_interface.dart';

final storageServiceProvider = Provider((ref) {
  final storage = ref.watch(appwriteStorageProvider);
  return StorageService(storage: storage);
});

class StorageService implements IStorageService {
  final Storage _storage;
  StorageService({required Storage storage}) : _storage = storage;

  @override
  Future<String> uploadFile(
    String path,
    String? fileName,
  ) async {
    String rawId = const Uuid().v1();
    final uuid = removeCharacterFromString(rawId, '-');
    final uploadedFile = await _storage.createFile(
      bucketId: AppwriteConstants.recipesBucketId,
      fileId: uuid,
      file: InputFile.fromPath(
        path: path,
        filename: fileName,
      ),
    );
    return uploadedFile.$id;
  }

  @override
  Future<void> deleteFile(String fileId) async {
    return await _storage.deleteFile(
      bucketId: AppwriteConstants.recipesBucketId,
      fileId: fileId,
    );
  }
}
